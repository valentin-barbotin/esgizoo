import { IError } from "./error.interface";

export interface IQueryReturn<T> {
	content?: T;
	error?: IError;
	stats?: {
		inserted?: number;
		updated?: number;
		deleted?: number;
	};
}