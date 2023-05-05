import { IError } from "./interfaces/error.interface";

export default class ErrorsUtil {
    static _401(additionnal: any): IError {
		return {
			code: 401,
			info: 'execko',
			error: 'ERROR_UNAUTHORIZED_ACTION',
			additional: JSON.parse(JSON.stringify(additionnal))
		};
    }

    static _404(additionnal: any): IError {
		return {
			code: 404,
			info: 'execko',
			error: 'ERROR_NO_DATA_FOUND',
			additional: JSON.parse(JSON.stringify(additionnal))
		};
    }

    static _405(additionnal: any): IError {
		return {
			code: 405,
			info: 'execko',
			error: 'ERROR_METHOD_NOT_ALLOWED',
			additional: JSON.parse(JSON.stringify(additionnal))
		};
    }

    static _412(additionnal: any): IError {
		return {
			code: 412,
			info: 'execko',
			error: 'ERROR_INVALID_PARAMETERS',
			additional: JSON.parse(JSON.stringify(additionnal))
		};
    }

    static _429(additionnal: any): IError {
		return {
			code: 429,
			info: 'execko',
			error: 'ERROR_RATE_LIMITED',
			additional: JSON.parse(JSON.stringify(additionnal))
		};
    }

    static _500(additionnal: any): IError {
		return {
			code: 500,
			info: 'execko',
			error: 'ERROR_SOMETHING_WENT_WRONG',
			additional: JSON.parse(JSON.stringify(additionnal))
		};
    }
}