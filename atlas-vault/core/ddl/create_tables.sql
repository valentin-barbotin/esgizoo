/*
** lov_informations
*/
DROP TABLE IF EXISTS zoodb.lov_informations CASCADE;
CREATE TABLE zoodb.lov_informations (
	ll_key			TEXT			NOT NULL,
	ll_value		TEXT			NOT NULL
);

ALTER TABLE zoodb.lov_informations ADD CONSTRAINT pk_informations PRIMARY KEY ( ll_key );

/*
** ref_blacklist
*/
DROP TABLE IF EXISTS zoodb.ref_blacklist CASCADE;
CREATE TABLE zoodb.ref_blacklist (
	id_blacklist		uuid			NOT NULL	DEFAULT gen_random_uuid()	,
	ll_blacklisted		TEXT			NOT NULL								,
	ll_comment			TEXT													,
	ts_created_at		TIMESTAMP		NOT NULL	DEFAULT CURRENT_TIMESTAMP	,
	ts_updated_at		TIMESTAMP		NOT NULL	DEFAULT CURRENT_TIMESTAMP	,
	flg_active			BOOLEAN			NOT NULL	DEFAULT TRUE
);

ALTER TABLE zoodb.ref_blacklist ADD CONSTRAINT pk_blacklist PRIMARY KEY ( id_blacklist );
