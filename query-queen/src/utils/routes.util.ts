import { Express } from "express";
import BlacklistRouter from "../routes/blacklist.route";

export default class RouterUtil {
    static init(app: Express): void {
		const version = app.get('version');
		const global = 'glob';

		app.use('/' + version + '/' + global + '/blacklist', BlacklistRouter);
    }
};