/*
**	zoodb.f_blacklist_contains
*/
CREATE OR REPLACE FUNCTION zoodb.f_blacklist_contains (
	p_ll_blacklisted		zoodb.ref_blacklist.ll_blacklisted%TYPE
) RETURNS BOOLEAN AS $f_blacklist_contains$
BEGIN
	RETURN(
		EXISTS(
			SELECT 1
				FROM zoodb.ref_blacklist AS blacklists
			WHERE 1=1
				AND blacklists.flg_active
				AND blacklists.ll_blacklisted = p_ll_blacklisted
		)
	);

	EXCEPTION
		WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'ERROR_NO_DATA_FOUND';
		WHEN CASE_NOT_FOUND THEN RAISE EXCEPTION 'ERROR_CASE_STATEMENT_NOT_FOUND';
		WHEN OTHERS THEN RAISE;
END;

	$f_blacklist_contains$
LANGUAGE plpgsql;



/*
**	zoodb.f_blacklist_exist
*/
CREATE OR REPLACE FUNCTION zoodb.f_blacklist_exist (
	p_id_blacklist		zoodb.ref_blacklist.id_blacklist%TYPE
) RETURNS BOOLEAN AS $f_blacklist_exist$
BEGIN
	RETURN(
		EXISTS(
			SELECT 1
				FROM zoodb.ref_blacklist AS blacklists
			WHERE 1=1
				AND blacklists.flg_active
				AND blacklists.id_blacklist = p_id_blacklist
		)
	);

	EXCEPTION
		WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'ERROR_NO_DATA_FOUND';
		WHEN CASE_NOT_FOUND THEN RAISE EXCEPTION 'ERROR_CASE_STATEMENT_NOT_FOUND';
		WHEN OTHERS THEN RAISE;
END;

	$f_blacklist_exist$
LANGUAGE plpgsql;



/*
**	zoodb.f_get_blacklist
*/
CREATE OR REPLACE FUNCTION zoodb.f_get_blacklist (
) RETURNS JSONB AS $f_get_blacklist$
DECLARE
	v_blacklist		JSONB;
BEGIN
	SELECT
		COALESCE(
			JSONB_AGG(
				(SELECT zoodb.f_get_blacklist_unit(blacklists.id_blacklist))->'data'->'blacklist_unit'
			),
			JSONB_BUILD_ARRAY()
		) INTO v_blacklist
	FROM zoodb.ref_blacklist AS blacklists
	WHERE 1=1
		AND blacklists.flg_active;

	RETURN (
		JSONB_BUILD_OBJECT (
			'info'          , 'execok'
			, 'data'  , JSONB_BUILD_OBJECT (
				'blacklist'	, v_blacklist
			)
		)
	);

	EXCEPTION
		WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'ERROR_NO_DATA_FOUND';
		WHEN CASE_NOT_FOUND THEN RAISE EXCEPTION 'ERROR_CASE_STATEMENT_NOT_FOUND';
		WHEN OTHERS THEN RAISE;
END;

	$f_get_blacklist$
LANGUAGE plpgsql;



/*
**	zoodb.f_get_blacklist_unit
*/
CREATE OR REPLACE FUNCTION zoodb.f_get_blacklist_unit (
	p_id_blacklist		zoodb.ref_blacklist.id_blacklist%TYPE
) RETURNS JSONB AS $f_get_blacklist_unit$
DECLARE
	v_blacklist_unit		JSONB;
BEGIN
	IF ((SELECT zoodb.f_blacklist_exist(p_id_blacklist)) <> TRUE) THEN
		RAISE EXCEPTION '{!}%{!}',
			JSONB_BUILD_OBJECT (
				'info'          , 'execko'
				, 'code'		, 404
				, 'error'		, 'ERROR_NOT_BLACKLISTED'
				, 'additional'	, JSONB_BUILD_OBJECT (
					'id'		, p_id_blacklist
				)
			)
		;
	END IF;

	SELECT
		JSONB_BUILD_OBJECT(
			'id', blacklists.id_blacklist,
			'blacklisted', blacklists.ll_blacklisted,
			'comment', blacklists.ll_comment,
			'createdAt', blacklists.ts_created_at
		) INTO v_blacklist_unit
	FROM zoodb.ref_blacklist AS blacklists
	WHERE 1=1
		AND blacklists.flg_active
		AND blacklists.id_blacklist = p_id_blacklist;

	RETURN (
		JSONB_BUILD_OBJECT (
			'info'          , 'execok'
			, 'data'  , JSONB_BUILD_OBJECT (
				'blacklist_unit'	, v_blacklist_unit
			)
		)
	);

	EXCEPTION
		WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'ERROR_NO_DATA_FOUND';
		WHEN CASE_NOT_FOUND THEN RAISE EXCEPTION 'ERROR_CASE_STATEMENT_NOT_FOUND';
		WHEN OTHERS THEN RAISE;
END;

	$f_get_blacklist_unit$
LANGUAGE plpgsql;



/*
**	zoodb.f_create_blacklist
*/
CREATE OR REPLACE FUNCTION zoodb.f_create_blacklist (
	p_ll_blacklisted	zoodb.ref_blacklist.ll_blacklisted%TYPE								,
	p_ll_comment		zoodb.ref_blacklist.ll_comment%TYPE	DEFAULT 'No comment'
) RETURNS JSONB AS $f_create_blacklist$
DECLARE
	v_ins		INTEGER	:= 0;
	v_upd		INTEGER	:= 0;
	v_del		INTEGER	:= 0;

	v_blacklist_unit	JSONB;
	v_id_blacklist		UUID;
BEGIN
	IF (SELECT zoodb.f_blacklist_contains(p_ll_blacklisted)) THEN
		RAISE EXCEPTION '{!}%{!}',
			JSONB_BUILD_OBJECT (
				'info'          , 'execko'
				, 'code'		, 409
				, 'error'		, 'ERROR_ALREADY_BLACKLISTED'
				, 'additional'	, JSONB_BUILD_OBJECT (
					'blacklisted'		, p_ll_blacklisted
				)
			)
		;
	END IF;

	INSERT INTO zoodb.ref_blacklist (ll_blacklisted, ll_comment)
	VALUES (
		p_ll_blacklisted,
		p_ll_comment
	) RETURNING id_blacklist INTO v_id_blacklist;
	GET DIAGNOSTICS v_ins = ROW_COUNT;

	SELECT zoodb.f_get_blacklist_unit(v_id_blacklist)->'data'->'blacklist_unit' INTO v_blacklist_unit;

	RETURN (
		JSONB_BUILD_OBJECT (
			'info'          , 'execok'
			, 'inserted'    , v_ins
			, 'updated'     , v_upd
			, 'deleted'     , v_del
			, 'data'  		, JSONB_BUILD_OBJECT (
				'blacklist_unit'		, v_blacklist_unit
			)
		)
	);

	EXCEPTION
		WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'ERROR_NO_DATA_FOUND';
		WHEN CASE_NOT_FOUND THEN RAISE EXCEPTION 'ERROR_CASE_STATEMENT_NOT_FOUND';
		WHEN OTHERS THEN RAISE;
END;

	$f_create_blacklist$
LANGUAGE plpgsql;



/*
**	zoodb.f_delete_blacklist
*/
CREATE OR REPLACE FUNCTION zoodb.f_delete_blacklist (
	p_id_blacklist		zoodb.ref_blacklist.id_blacklist%TYPE
) RETURNS JSONB AS $f_delete_blacklist$
DECLARE
	v_ins	INTEGER	:= 0;
	v_upd	INTEGER	:= 0;
	v_del	INTEGER	:= 0;
BEGIN
	IF ((SELECT zoodb.f_blacklist_exist(p_id_blacklist)) <> TRUE) THEN
		RAISE EXCEPTION '{!}%{!}',
			JSONB_BUILD_OBJECT (
				'info'          , 'execko'
				, 'code'		, 404
				, 'error'		, 'ERROR_NOT_BLACKLISTED'
				, 'additional'	, JSONB_BUILD_OBJECT (
					'id'		, p_id_blacklist
				)
			)
		;
	END IF;

	UPDATE zoodb.ref_blacklist AS blacklists
	SET
		flg_active = FALSE,
		ts_updated_at = CURRENT_TIMESTAMP(1)
	WHERE  1=1
		AND blacklists.flg_active
		AND blacklists.id_blacklist = p_id_blacklist;
	GET DIAGNOSTICS v_upd = ROW_COUNT;

	RETURN (
		JSONB_BUILD_OBJECT (
			'info'          , 'execok'
			, 'inserted'    , v_ins
			, 'updated'     , v_upd
			, 'deleted'     , v_del
			, 'additional'  , JSONB_BUILD_OBJECT (
				'id'       	, p_id_blacklist
			)
		)
	);

	EXCEPTION
		WHEN NO_DATA_FOUND THEN RAISE EXCEPTION 'ERROR_NO_DATA_FOUND';
		WHEN CASE_NOT_FOUND THEN RAISE EXCEPTION 'ERROR_CASE_STATEMENT_NOT_FOUND';
		WHEN OTHERS THEN RAISE;
END;

	$f_delete_blacklist$
LANGUAGE plpgsql;
