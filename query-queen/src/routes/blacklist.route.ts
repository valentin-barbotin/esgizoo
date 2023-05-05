import { Router, Request, Response, NextFunction } from "express";
import ResponsesUtil from "../utils/responses.util";
import service from "../services/blacklist.service";

const router: Router = Router();

router.get('/', async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const result = await service.getAll();
	ResponsesUtil.handleResult(res, result);
});

router.post('/', async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    let options = {
        "id": req.body.id,
        "comment": req.body.comment,
    };

	if(!options.id || !options.comment) return ResponsesUtil.invalidParameters(res);

    const result = await service.create(options);
	ResponsesUtil.handleResult(res, result);
});

router.delete('/', async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    let options = {
        "id": req.body.id,
    };

	if(!options.id) return ResponsesUtil.invalidParameters(res);

    const result = await service.delete(options);
	ResponsesUtil.handleResult(res, result);
});

/***************************************************************
* NOT ALLOWED METHODS HANDLING
***************************************************************/

router.all('/', async (req: Request, res: Response, next: NextFunction): Promise<void> => ResponsesUtil.methodNotAllowed(res));
router.all('/contains', async (req: Request, res: Response, next: NextFunction): Promise<void> => ResponsesUtil.methodNotAllowed(res));

/**************************************************************/

export default router;