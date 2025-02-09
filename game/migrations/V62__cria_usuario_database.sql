
-- REVOKE ALL ON SCHEMA public FROM PUBLIC;
-- GRANT USAGE ON SCHEMA public TO PUBLIC;
-- GRANT CREATE ON SCHEMA public TO cdz;
-- ALTER SCHEMA public OWNER TO cdz;

-- CREATE USER aplicacao WITH PASSWORD 'sbd1_2024.2@cdz';


-- GRANT USAGE ON SCHEMA public TO aplicacao;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO aplicacao;

-- GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO aplicacao;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO aplicacao;
-- GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public TO aplicacao;


-- ALTER DEFAULT PRIVILEGES IN SCHEMA public
-- GRANT EXECUTE ON FUNCTIONS TO aplicacao;

-- DO $$
-- DECLARE
--     rec RECORD;
-- BEGIN
--     FOR rec IN 
--       SELECT 
--         p.proname,
--         pg_catalog.pg_get_function_identity_arguments(p.oid) AS args
--       FROM pg_proc p
--       JOIN pg_namespace n ON n.oid = p.pronamespace
--       WHERE n.nspname = 'public'
--         AND p.prokind = 'p'
--     LOOP
--         RAISE NOTICE 'Granting EXECUTE on procedure: public.%(%).', rec.proname, rec.args;
--         EXECUTE 'GRANT EXECUTE ON PROCEDURE public.' || quote_ident(rec.proname) ||
--                 '(' || rec.args || ') TO aplicacao';
--     END LOOP;
-- END
-- $$;



