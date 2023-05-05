/*
**	Blacklist
*/
DROP FUNCTION IF EXISTS zoodb.f_blacklist_contains(text) CASCADE; -- ll_id
DROP FUNCTION IF EXISTS zoodb.f_blacklist_exist(uuid) CASCADE; -- id_blacklist
DROP FUNCTION IF EXISTS zoodb.f_get_blacklist(text) CASCADE; -- id_requester
DROP FUNCTION IF EXISTS zoodb.f_get_blacklist_unit(uuid, text) CASCADE; -- id_blacklist, id_requester
DROP FUNCTION IF EXISTS zoodb.f_create_blacklist(text, text, text) CASCADE; -- ll_id, ll_comment, id_requester
DROP FUNCTION IF EXISTS zoodb.f_delete_blacklist(uuid, text) CASCADE; -- id_blacklist, id_requester
