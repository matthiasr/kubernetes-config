DO
$body$
BEGIN
  IF NOT EXISTS (
    SELECT *
    FROM   pg_catalog.pg_user
    WHERE  usename = 'logformat') THEN

    CREATE ROLE logformat LOGIN PASSWORD 'changeme';
  END IF;
END
$body$;

CREATE SCHEMA IF NOT EXISTS AUTHORIZATION logformat;
ALTER ROLE logformat SET search_path=logformat;
