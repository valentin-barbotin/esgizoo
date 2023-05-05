export interface IResult<T> {
	data?: T;
	additional?: any;
	inserted?: number;
	updated?: number;
	deleted?: number;
	info: 'execok';
}