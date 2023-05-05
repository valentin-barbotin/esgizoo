import { Response } from "express";
import { IQueryReturn } from "./interfaces/queryreturn.interface";
import ErrorsUtil from "./errors.util";

export default class ResponsesUtil {
    static unauthorizedAction(res: Response): void {
		ResponsesUtil.handleResult(
			res, { error: ErrorsUtil._401('{}') }
		);
    }

    static notFound(res: Response): void {
		ResponsesUtil.handleResult(
			res, { error: ErrorsUtil._404('{}') }
		);
    }

    static methodNotAllowed(res: Response): void {
		ResponsesUtil.handleResult(
			res, { error: ErrorsUtil._405('{}') }
		);
    }

    static invalidParameters(res: Response): void {
		ResponsesUtil.handleResult(
			res, { error: ErrorsUtil._412('{}') }
		);
    }

    static tooManyRequest(res: Response): void {
		ResponsesUtil.handleResult(
			res, { error: ErrorsUtil._429('{}') }
		);
    }

    static somethingWentWrong(res: Response): void {
		ResponsesUtil.handleResult(
			res, { error: ErrorsUtil._500('{}') }
		);
    }

	static handleResult(res: Response, result: IQueryReturn<any>): void {
		res.status(result.error ? result.error.code : 200).json({data: result});
	}
}