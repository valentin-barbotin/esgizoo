import DatabaseUtil from "../utils/database.util";
import { IQueryReturn } from "../utils/interfaces/queryreturn.interface";
import { IBlacklist } from "../utils/interfaces/models/blacklist.model";

export default class BranchesService {
    static async getAll(): Promise<IQueryReturn<IBlacklist[]>> {
        return await DatabaseUtil.queryF<IBlacklist[]>("f_get_blacklist", [], 'blacklist');
    }

    static async create(options: { id: string; comment: string; }): Promise<IQueryReturn<IBlacklist>> {
        return await DatabaseUtil.queryF<IBlacklist>("f_create_blacklist", [options.id, options.comment], 'blacklist_unit');
    }

    static async delete(options: { id: string; }): Promise<IQueryReturn<IBlacklist>> {
        return await DatabaseUtil.queryF<IBlacklist>("f_delete_blacklist", [options.id]);
    }
};