import { Express } from "express";
import { Pool, QueryResult } from 'pg';
import { IResult } from "./interfaces/result.interface";
import { IError } from "./interfaces/error.interface";
import { IQueryReturn } from "./interfaces/queryreturn.interface";
import ErrorsUtil from "./errors.util";

export default class DatabaseUtil {
	static pool: Pool;

	static init(app: Express){
		this.pool = new Pool({
			host: app.get('dbHost'),
			user: app.get('dbUser'),
			password: app.get('dbPsswd'),
			port: app.get('dbPort'),
			max: 100,
			database: 'zoo',
			connectionTimeoutMillis: 5000
		})
	}

    static async queryF<T>(func: string, values: (number|boolean|string|null)[], searched?:string) : Promise<IQueryReturn<T>> {
		if(!func.match(/^f_[a-zA-Z_0-9]+$/)) throw new TypeError('Requested function does not have a correct name format');

        return new Promise<IQueryReturn<T>>((resolve, reject) => {
            this.pool.query('SELECT zoo.' + func + '(' + values.map((el, i) => '$' + (i+1)).join(',') + ')', values, (err: Error, res: QueryResult<any>) => {
				if(err){
					const segs = err.message.match(/^\{\!\}(\{.*\})\{\!\}$/i);
					if(segs){
						const errJson: IError = JSON.parse(segs[1]);
						resolve({error: errJson});
					} else {
						console.error(err)
						resolve({error: ErrorsUtil._500({message: err.message})});
					}
				} else {
					if(res.rowCount === 1 && res.fields[0].name.startsWith('f_')){
						const resJson: IResult<T> = res.rows[0][res.fields[0].name];
						let finalRes: IQueryReturn<T> = {};

						if(searched && resJson.data) finalRes.content = (resJson.data as any)[searched];
						else if(resJson.additional) finalRes.content = resJson.additional;
						if(resJson.inserted || resJson.updated || resJson.deleted){
							finalRes.stats = {
								inserted: resJson.inserted || 0,
								updated: resJson.updated || 0,
								deleted: resJson.deleted || 0
							}
						}

						resolve(finalRes);
					} else reject(new TypeError('Invalid database query return type'));
				}
            })
        });
    }
}