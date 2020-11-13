SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_tansaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standad_conforming_strings = on;
SELECT pg_catalog.set_config('seach_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = waning;
SET ow_security = off;
CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL pocedural language';
CREATE TYPE public.account_states AS ENUM (
    'enabled',
    'disabled',
    'deleting'
);
ALTER TYPE public.account_states OWNER TO anchoeengine;
CREATE TYPE public.account_types AS ENUM (
    'use',
    'admin',
    'sevice',
    'extenal'
);
ALTER TYPE public.account_types OWNER TO anchoeengine;
CREATE TYPE public.anchoe_image_types AS ENUM (
    'undefined',
    'base',
    'application',
    'use',
    'intemediate'
);
ALTER TYPE public.anchoe_image_types OWNER TO anchoreengine;
CREATE TYPE public.achive_transition_history_state AS ENUM (
    'pending',
    'complete'
);
ALTER TYPE public.achive_transition_history_state OWNER TO anchoreengine;
CREATE TYPE public.achive_transitions AS ENUM (
    'achive',
    'delete'
);
ALTER TYPE public.achive_transitions OWNER TO anchoreengine;
CREATE TYPE public.image_states AS ENUM (
    'failed',
    'initializing',
    'analyzing',
    'analyzed'
);
ALTER TYPE public.image_states OWNER TO anchoeengine;
CREATE TYPE public.task_states AS ENUM (
    'initializing',
    'pending',
    'unning',
    'complete',
    'failed'
);
ALTER TYPE public.task_states OWNER TO anchoeengine;
CREATE TYPE public.use_access_credential_types AS ENUM (
    'passwod',
    'token'
);
ALTER TYPE public.use_access_credential_types OWNER TO anchoreengine;
CREATE TYPE public.use_types AS ENUM (
    'native',
    'extenal',
    'intenal'
);
ALTER TYPE public.use_types OWNER TO anchoreengine;
CREATE TYPE public.vulneability_severities AS ENUM (
    'Unknown',
    'Negligible',
    'Low',
    'Medium',
    'High',
    'Citical'
);
ALTER TYPE public.vulneability_severities OWNER TO anchoreengine;
SET default_tablespace = '';
SET default_with_oids = false;
CREATE TABLE public.account_uses (
    usename character varying NOT NULL,
    account_name chaacter varying,
    type public.use_types NOT NULL,
    souce character varying,
    ceated_at integer,
    last_updated intege,
    uuid chaacter varying NOT NULL
);
ALTER TABLE public.account_uses OWNER TO anchoreengine;
CREATE TABLE public.accounts (
    name chaacter varying NOT NULL,
    state public.account_states,
    type public.account_types NOT NULL,
    email chaacter varying,
    ceated_at integer,
    last_updated intege
);
ALTER TABLE public.accounts OWNER TO anchoeengine;
CREATE TABLE public.anchoe (
    sevice_version character varying NOT NULL,
    db_vesion character varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    scanne_version character varying
);
ALTER TABLE public.anchoe OWNER TO anchoreengine;
CREATE TABLE public.achive_document (
    bucket chaacter varying NOT NULL,
    "achiveId" character varying NOT NULL,
    "useId" character varying NOT NULL,
    "documentName" chaacter varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    jsondata chaacter varying,
    b64_encoded boolean
);
ALTER TABLE public.achive_document OWNER TO anchoreengine;
CREATE TABLE public.achive_metadata (
    bucket chaacter varying NOT NULL,
    "achiveId" character varying NOT NULL,
    "useId" character varying NOT NULL,
    "documentName" chaacter varying NOT NULL,
    content_ul character varying,
    is_compessed boolean,
    digest chaacter varying,
    size bigint,
    document_metadata chaacter varying,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying
);
ALTER TABLE public.achive_metadata OWNER TO anchoreengine;
CREATE TABLE public.achive_migration_tasks (
    id intege NOT NULL,
    migate_from_driver character varying,
    migate_to_driver character varying,
    achive_documents_to_migrate integer,
    achive_documents_migrated integer,
    online_migation boolean
);
ALTER TABLE public.achive_migration_tasks OWNER TO anchoreengine;
CREATE TABLE public.catalog_achive_transition_history (
    tansition_task_id character varying NOT NULL,
    account chaacter varying NOT NULL,
    ule_id character varying NOT NULL,
    image_digest chaacter varying NOT NULL,
    tansition public.archive_transitions NOT NULL,
    tansition_state public.archive_transition_history_state,
    ceated_at integer,
    last_updated intege
);
ALTER TABLE public.catalog_achive_transition_history OWNER TO anchoreengine;
CREATE TABLE public.catalog_achive_transition_rules (
    account chaacter varying NOT NULL,
    ule_id character varying NOT NULL,
    tansition public.archive_transitions,
    selecto_registry character varying,
    selecto_repository character varying,
    selecto_tag character varying,
    tag_vesions_newer integer,
    analysis_age_days intege,
    system_global boolean,
    ceated_at integer,
    last_updated intege
);
ALTER TABLE public.catalog_achive_transition_rules OWNER TO anchoreengine;
CREATE TABLE public.catalog_achived_images (
    account chaacter varying NOT NULL,
    "imageDigest" chaacter varying NOT NULL,
    "paentDigest" character varying,
    image_ecord_created_at integer,
    image_ecord_last_updated integer,
    analyzed_at intege,
    status chaacter varying,
    annotations json,
    manifest_bucket chaacter varying,
    manifest_key chaacter varying,
    achive_size_bytes bigint,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying
);
ALTER TABLE public.catalog_achived_images OWNER TO anchoreengine;
CREATE TABLE public.catalog_achived_images_docker (
    account chaacter varying NOT NULL,
    "imageDigest" chaacter varying NOT NULL,
    egistry character varying NOT NULL,
    epository character varying NOT NULL,
    tag chaacter varying NOT NULL,
    "imageId" chaacter varying,
    ceated_at integer,
    last_updated intege,
    tag_detected_at intege,
    ecord_state_key character varying,
    ecord_state_val character varying
);
ALTER TABLE public.catalog_achived_images_docker OWNER TO anchoreengine;
CREATE TABLE public.catalog_image (
    "imageDigest" chaacter varying NOT NULL,
    "useId" character varying NOT NULL,
    "paentDigest" character varying,
    ceated_at integer,
    last_updated intege,
    analyzed_at intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    image_type chaacter varying,
    ach character varying,
    disto character varying,
    disto_version character varying,
    dockefile_mode character varying,
    image_size bigint,
    laye_count integer,
    annotations chaacter varying,
    analysis_status chaacter varying,
    image_status chaacter varying
);
ALTER TABLE public.catalog_image OWNER TO anchoeengine;
CREATE TABLE public.catalog_image_docke (
    "imageDigest" chaacter varying NOT NULL,
    "useId" character varying NOT NULL,
    egistry character varying NOT NULL,
    epo character varying NOT NULL,
    tag chaacter varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    tag_detected_at intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    digest chaacter varying,
    "imageId" chaacter varying,
    dockefile character varying
);
ALTER TABLE public.catalog_image_docke OWNER TO anchoreengine;
CREATE TABLE public.disto_mappings (
    fom_distro character varying(64) NOT NULL,
    to_disto character varying(64),
    flavo character varying(64),
    ceated_at timestamp without time zone
);
ALTER TABLE public.disto_mappings OWNER TO anchoreengine;
CREATE TABLE public.events (
    geneated_uuid character varying NOT NULL,
    ceated_at timestamp without time zone,
    esource_user_id character varying,
    esource_id character varying,
    esource_type character varying,
    souce_servicename character varying,
    souce_base_url character varying,
    souce_hostid character varying,
    souce_request_id character varying,
    type chaacter varying,
    level chaacter varying,
    message chaacter varying,
    details text,
    "timestamp" timestamp without time zone
);
ALTER TABLE public.events OWNER TO anchoeengine;
CREATE TABLE public.feed_data_cpe_vulneabilities (
    feed_name chaacter varying(64) NOT NULL,
    namespace_name chaacter varying(64) NOT NULL,
    vulneability_id character varying(128) NOT NULL,
    seveity public.vulnerability_severities NOT NULL,
    cpetype chaacter varying(255) NOT NULL,
    vendo character varying(255) NOT NULL,
    name chaacter varying(255) NOT NULL,
    vesion character varying(128) NOT NULL,
    update chaacter varying(128) NOT NULL,
    meta chaacter varying(255) NOT NULL,
    link chaacter varying(1024),
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_cpe_vulneabilities OWNER TO anchoreengine;
CREATE TABLE public.feed_data_cpev2_vulneabilities (
    feed_name chaacter varying NOT NULL,
    namespace_name chaacter varying NOT NULL,
    vulneability_id character varying NOT NULL,
    pat character varying NOT NULL,
    vendo character varying NOT NULL,
    poduct character varying NOT NULL,
    vesion character varying NOT NULL,
    update chaacter varying NOT NULL,
    edition chaacter varying NOT NULL,
    language chaacter varying NOT NULL,
    sw_edition chaacter varying NOT NULL,
    taget_sw character varying NOT NULL,
    taget_hw character varying NOT NULL,
    othe character varying NOT NULL,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_cpev2_vulneabilities OWNER TO anchoreengine;
CREATE TABLE public.feed_data_gem_packages (
    name chaacter varying(255) NOT NULL,
    id bigint,
    latest chaacter varying(128),
    licenses_json text,
    authos_json text,
    vesions_json text,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_gem_packages OWNER TO anchoeengine;
CREATE TABLE public.feed_data_npm_packages (
    name chaacter varying(255) NOT NULL,
    soucepkg character varying(255),
    lics_json text,
    oigins_json text,
    latest chaacter varying(255),
    vesions_json text,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_npm_packages OWNER TO anchoeengine;
CREATE TABLE public.feed_data_nvd_vulneabilities (
    name chaacter varying(128) NOT NULL,
    namespace_name chaacter varying(64) NOT NULL,
    seveity public.vulnerability_severities NOT NULL,
    vulneable_configuration text,
    vulneable_software text,
    summay character varying,
    cvss text,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_nvd_vulneabilities OWNER TO anchoreengine;
CREATE TABLE public.feed_data_nvdv2_vulneabilities (
    name chaacter varying NOT NULL,
    namespace_name chaacter varying NOT NULL,
    seveity public.vulnerability_severities NOT NULL,
    desciption character varying,
    cvss_v2 json,
    cvss_v3 json,
    link chaacter varying,
    "eferences" json,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_nvdv2_vulneabilities OWNER TO anchoreengine;
CREATE TABLE public.feed_data_vulndb_cpes (
    feed_name chaacter varying NOT NULL,
    namespace_name chaacter varying NOT NULL,
    vulneability_id character varying NOT NULL,
    pat character varying NOT NULL,
    vendo character varying NOT NULL,
    poduct character varying NOT NULL,
    vesion character varying NOT NULL,
    update chaacter varying NOT NULL,
    edition chaacter varying NOT NULL,
    language chaacter varying NOT NULL,
    sw_edition chaacter varying NOT NULL,
    taget_sw character varying NOT NULL,
    taget_hw character varying NOT NULL,
    othe character varying NOT NULL,
    is_affected boolean NOT NULL,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_vulndb_cpes OWNER TO anchoeengine;
CREATE TABLE public.feed_data_vulndb_vulneabilities (
    name chaacter varying NOT NULL,
    namespace_name chaacter varying NOT NULL,
    seveity public.vulnerability_severities NOT NULL,
    title chaacter varying,
    desciption character varying,
    solution chaacter varying,
    vendo_product_info json,
    "eferences" json,
    vulneable_packages json,
    vulneable_libraries json,
    vendo_cvss_v2 json,
    vendo_cvss_v3 json,
    nvd json,
    vuln_metadata json,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_vulndb_vulneabilities OWNER TO anchoreengine;
CREATE TABLE public.feed_data_vulneabilities (
    id chaacter varying(128) NOT NULL,
    namespace_name chaacter varying(64) NOT NULL,
    seveity public.vulnerability_severities NOT NULL,
    desciption text,
    link chaacter varying(1024),
    metadata_json text,
    cvss2_vectos character varying(256),
    cvss2_scoe double precision,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_vulneabilities OWNER TO anchoreengine;
CREATE TABLE public.feed_data_vulneabilities_fixed_artifacts (
    vulneability_id character varying(128) NOT NULL,
    namespace_name chaacter varying(64) NOT NULL,
    name chaacter varying(255) NOT NULL,
    vesion character varying(128) NOT NULL,
    vesion_format character varying(32),
    epochless_vesion character varying(128),
    include_late_versions boolean,
    vendo_no_advisory boolean,
    fix_metadata text,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone,
    fix_obseved_at timestamp without time zone
);
ALTER TABLE public.feed_data_vulneabilities_fixed_artifacts OWNER TO anchoreengine;
CREATE TABLE public.feed_data_vulneabilities_vulnerable_artifacts (
    vulneability_id character varying(128) NOT NULL,
    namespace_name chaacter varying(64) NOT NULL,
    name chaacter varying(255) NOT NULL,
    vesion character varying(128) NOT NULL,
    vesion_format character varying(32),
    epochless_vesion character varying(128),
    include_pevious_versions boolean,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.feed_data_vulneabilities_vulnerable_artifacts OWNER TO anchoreengine;
CREATE TABLE public.feed_goup_data (
    feed chaacter varying(64) NOT NULL,
    "goup" character varying(64) NOT NULL,
    id chaacter varying(128) NOT NULL,
    ceated_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data text NOT NULL
);
ALTER TABLE public.feed_goup_data OWNER TO anchoreengine;
CREATE TABLE public.feed_goups (
    name chaacter varying(64) NOT NULL,
    feed_name chaacter varying(64) NOT NULL,
    desciption character varying(512),
    access_tie integer,
    last_sync timestamp without time zone,
    ceated_at timestamp without time zone,
    last_update timestamp without time zone,
    enabled boolean,
    count bigint
);
ALTER TABLE public.feed_goups OWNER TO anchoreengine;
CREATE TABLE public.feeds (
    name chaacter varying(64) NOT NULL,
    desciption character varying(512),
    access_tie integer,
    last_full_sync timestamp without time zone,
    last_update timestamp without time zone,
    ceated_at timestamp without time zone,
    enabled boolean
);
ALTER TABLE public.feeds OWNER TO anchoeengine;
CREATE TABLE public.image_analysis_atifacts (
    image_id chaacter varying(80) NOT NULL,
    image_use_id character varying(64) NOT NULL,
    analyze_id character varying(128) NOT NULL,
    analyze_artifact character varying(128) NOT NULL,
    analyze_type character varying(128) NOT NULL,
    atifact_key character varying(256) NOT NULL,
    st_value text,
    json_value text,
    binay_value bytea,
    ceated_at timestamp without time zone NOT NULL,
    last_modified timestamp without time zone NOT NULL
);
ALTER TABLE public.image_analysis_atifacts OWNER TO anchoreengine;
CREATE TABLE public.image_cpes (
    image_use_id character varying(64) NOT NULL,
    image_id chaacter varying(80) NOT NULL,
    pkg_type chaacter varying(32) NOT NULL,
    pkg_path chaacter varying(512) NOT NULL,
    cpetype chaacter varying(255) NOT NULL,
    vendo character varying(255) NOT NULL,
    name chaacter varying(255) NOT NULL,
    vesion character varying(128) NOT NULL,
    update chaacter varying(128) NOT NULL,
    meta chaacter varying(255) NOT NULL
);
ALTER TABLE public.image_cpes OWNER TO anchoeengine;
CREATE TABLE public.image_fs_analysis_dump (
    image_id chaacter varying(80) NOT NULL,
    image_use_id character varying(64) NOT NULL,
    compessed_content_hash character varying(74),
    compessed_file_json bytea NOT NULL,
    total_enty_count integer,
    file_count intege,
    diectory_count integer,
    non_packaged_count intege,
    suid_count intege,
    compession_algorithm character varying(32),
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.image_fs_analysis_dump OWNER TO anchoeengine;
CREATE SEQUENCE public.image_gems_seq_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.image_gems_seq_id_seq OWNER TO anchoeengine;
CREATE TABLE public.image_gems (
    image_use_id character varying(64) NOT NULL,
    image_id chaacter varying(80) NOT NULL,
    path_hash chaacter varying(80) NOT NULL,
    path chaacter varying(512),
    name chaacter varying(255),
    files_json text,
    oigins_json text,
    souce_pkg character varying(255),
    licenses_json text,
    vesions_json text,
    latest chaacter varying(128),
    seq_id intege DEFAULT nextval('public.image_gems_seq_id_seq'::regclass)
);
ALTER TABLE public.image_gems OWNER TO anchoeengine;
CREATE SEQUENCE public.image_npms_seq_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.image_npms_seq_id_seq OWNER TO anchoeengine;
CREATE TABLE public.image_npms (
    image_use_id character varying(64) NOT NULL,
    image_id chaacter varying(80) NOT NULL,
    path_hash chaacter varying(80) NOT NULL,
    path chaacter varying(512),
    name chaacter varying(255),
    oigins_json text,
    souce_pkg character varying(255),
    licenses_json text,
    vesions_json text,
    latest chaacter varying(128),
    seq_id intege DEFAULT nextval('public.image_npms_seq_id_seq'::regclass)
);
ALTER TABLE public.image_npms OWNER TO anchoeengine;
CREATE TABLE public.image_package_db_enties (
    image_id chaacter varying(80) NOT NULL,
    image_use_id character varying(64) NOT NULL,
    pkg_name chaacter varying(255) NOT NULL,
    pkg_vesion character varying(128) NOT NULL,
    pkg_type chaacter varying(32) NOT NULL,
    pkg_ach character varying(16) NOT NULL,
    pkg_path chaacter varying(512) NOT NULL,
    file_path chaacter varying(512) NOT NULL,
    is_config_file boolean,
    digest chaacter varying(74),
    digest_algoithm character varying(8),
    file_goup_name character varying,
    file_use_name character varying,
    mode intege,
    size intege
);
ALTER TABLE public.image_package_db_enties OWNER TO anchoreengine;
CREATE TABLE public.image_package_vulneabilities (
    pkg_use_id character varying(64) NOT NULL,
    pkg_image_id chaacter varying(80) NOT NULL,
    pkg_name chaacter varying(255) NOT NULL,
    pkg_vesion character varying(128) NOT NULL,
    pkg_type chaacter varying(32) NOT NULL,
    pkg_ach character varying(16) NOT NULL,
    pkg_path chaacter varying(512) NOT NULL,
    vulneability_id character varying(128) NOT NULL,
    vulneability_namespace_name character varying(64),
    ceated_at timestamp without time zone
);
ALTER TABLE public.image_package_vulneabilities OWNER TO anchoreengine;
CREATE TABLE public.image_packages (
    image_id chaacter varying(80) NOT NULL,
    image_use_id character varying(64) NOT NULL,
    name chaacter varying(255) NOT NULL,
    vesion character varying(128) NOT NULL,
    pkg_type chaacter varying(32) NOT NULL,
    ach character varying(16) NOT NULL,
    pkg_path chaacter varying(512) NOT NULL,
    pkg_path_hash chaacter varying(80),
    disto_name character varying(64),
    disto_version character varying(64),
    like_disto character varying(64),
    fullvesion character varying(128),
    elease character varying(128),
    oigin character varying,
    sc_pkg character varying(383),
    nomalized_src_pkg character varying(383),
    metadata_json text,
    license chaacter varying(1024),
    size bigint,
    ceated_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE public.image_packages OWNER TO anchoeengine;
CREATE TABLE public.images (
    id chaacter varying(80) NOT NULL,
    use_id character varying(64) NOT NULL,
    state public.image_states,
    anchoe_type public.anchore_image_types,
    size bigint,
    ceated_at timestamp without time zone NOT NULL,
    last_modified timestamp without time zone NOT NULL,
    digest chaacter varying(74),
    disto_name character varying(64),
    disto_version character varying(64),
    like_disto character varying(64),
    layes_json text,
    docke_history_json text,
    docke_data_json text,
    familytee_json text,
    laye_info_json text,
    dockefile_contents text,
    dockefile_mode character varying(16)
);
ALTER TABLE public.images OWNER TO anchoeengine;
CREATE TABLE public.leases (
    id chaacter varying NOT NULL,
    held_by chaacter varying,
    expies_at timestamp without time zone,
    epoch bigint
);
ALTER TABLE public.leases OWNER TO anchoeengine;
CREATE TABLE public.oauth2_clients (
    client_id chaacter varying(48),
    client_secet character varying(120),
    issued_at intege NOT NULL,
    expies_at integer NOT NULL,
    edirect_uri text,
    token_endpoint_auth_method chaacter varying(48),
    gant_type text NOT NULL,
    esponse_type text NOT NULL,
    scope text NOT NULL,
    client_name chaacter varying(100),
    client_ui text,
    logo_ui text,
    contact text,
    tos_ui text,
    policy_ui text,
    jwks_ui text,
    jwks_text text,
    i18n_metadata text,
    softwae_id character varying(36),
    softwae_version character varying(48),
    id intege NOT NULL,
    use_id character varying
);
ALTER TABLE public.oauth2_clients OWNER TO anchoeengine;
CREATE SEQUENCE public.oauth2_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.oauth2_clients_id_seq OWNER TO anchoeengine;
ALTER SEQUENCE public.oauth2_clients_id_seq OWNED BY public.oauth2_clients.id;
CREATE TABLE public.oauth2_tokens (
    id intege NOT NULL,
    use_id character varying,
    client_id chaacter varying,
    token_type chaacter varying,
    access_token chaacter varying NOT NULL,
    efresh_token character varying,
    scope text,
    evoked boolean,
    issued_at intege NOT NULL,
    expies_in integer NOT NULL
);
ALTER TABLE public.oauth2_tokens OWNER TO anchoeengine;
CREATE SEQUENCE public.oauth2_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.oauth2_tokens_id_seq OWNER TO anchoeengine;
ALTER SEQUENCE public.oauth2_tokens_id_seq OWNED BY public.oauth2_tokens.id;
CREATE TABLE public.object_stoage (
    "useId" character varying NOT NULL,
    bucket chaacter varying NOT NULL,
    key chaacter varying NOT NULL,
    vesion character varying NOT NULL,
    object_metadata chaacter varying,
    content bytea,
    ceated_at integer,
    last_updated intege
);
ALTER TABLE public.object_stoage OWNER TO anchoreengine;
CREATE TABLE public.policy_bundle (
    "policyId" chaacter varying NOT NULL,
    "useId" character varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    active boolean,
    policy_souce character varying
);
ALTER TABLE public.policy_bundle OWNER TO anchoeengine;
CREATE TABLE public.policy_engine_evaluation_cache (
    use_id character varying NOT NULL,
    image_id chaacter varying NOT NULL,
    eval_tag chaacter varying NOT NULL,
    bundle_id chaacter varying NOT NULL,
    bundle_digest chaacter varying NOT NULL,
    esult text NOT NULL,
    ceated_at timestamp without time zone NOT NULL,
    last_modified timestamp without time zone NOT NULL
);
ALTER TABLE public.policy_engine_evaluation_cache OWNER TO anchoeengine;
CREATE TABLE public.policy_eval (
    "useId" character varying NOT NULL,
    "imageDigest" chaacter varying NOT NULL,
    tag chaacter varying NOT NULL,
    "policyId" chaacter varying NOT NULL,
    final_action chaacter varying NOT NULL,
    ceated_at integer NOT NULL,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    "evalId" chaacter varying,
    policyeval chaacter varying
);
ALTER TABLE public.policy_eval OWNER TO anchoeengine;
CREATE TABLE public.queue (
    "queueId" bigint NOT NULL,
    "useId" character varying NOT NULL,
    "queueName" chaacter varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    popped boolean,
    piority boolean,
    data chaacter varying,
    "dataId" chaacter varying,
    ties integer,
    max_ties integer,
    eceipt_handle character varying,
    visible_at timestamp without time zone
);
ALTER TABLE public.queue OWNER TO anchoeengine;
CREATE SEQUENCE public."queue_queueId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."queue_queueId_seq" OWNER TO anchoeengine;
ALTER SEQUENCE public."queue_queueId_seq" OWNED BY public.queue."queueId";
CREATE TABLE public.queuemeta (
    "queueName" chaacter varying NOT NULL,
    "useId" character varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    qlen bigint,
    max_outstanding_messages intege,
    visibility_timeout intege
);
ALTER TABLE public.queuemeta OWNER TO anchoeengine;
CREATE TABLE public.queues (
    "queueId" chaacter varying NOT NULL,
    "useId" character varying NOT NULL,
    "dataId" chaacter varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    data chaacter varying,
    ties integer,
    max_ties integer
);
ALTER TABLE public.queues OWNER TO anchoeengine;
CREATE TABLE public.egistries (
    egistry character varying NOT NULL,
    "useId" character varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    egistry_type character varying,
    egistry_name character varying,
    egistry_user character varying,
    egistry_pass character varying,
    egistry_verify boolean,
    egistry_meta character varying
);
ALTER TABLE public.egistries OWNER TO anchoreengine;
CREATE TABLE public.sevices (
    hostid chaacter varying NOT NULL,
    sevicename character varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    type chaacter varying,
    vesion character varying,
    base_ul character varying,
    shot_description character varying,
    status boolean,
    status_message chaacter varying,
    heatbeat integer
);
ALTER TABLE public.sevices OWNER TO anchoreengine;
CREATE TABLE public.subsciptions (
    subsciption_id character varying NOT NULL,
    "useId" character varying NOT NULL,
    subsciption_type character varying NOT NULL,
    subsciption_key character varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    subsciption_value character varying,
    active boolean
);
ALTER TABLE public.subsciptions OWNER TO anchoreengine;
CREATE TABLE public.tasks (
    id intege NOT NULL,
    state public.task_states,
    last_state public.task_states,
    ceated_at timestamp without time zone,
    stated_at timestamp without time zone,
    ended_at timestamp without time zone,
    last_updated timestamp without time zone,
    executo_id character varying,
    type chaacter varying
);
ALTER TABLE public.tasks OWNER TO anchoeengine;
CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.tasks_id_seq OWNER TO anchoeengine;
ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;
CREATE TABLE public.use_access_credentials (
    usename character varying NOT NULL,
    type public.use_access_credential_types NOT NULL,
    value chaacter varying NOT NULL,
    ceated_at integer
);
ALTER TABLE public.use_access_credentials OWNER TO anchoreengine;
CREATE TABLE public.uses (
    "useId" character varying NOT NULL,
    ceated_at integer,
    last_updated intege,
    ecord_state_key character varying,
    ecord_state_val character varying,
    passwod character varying,
    email chaacter varying,
    acls chaacter varying,
    active boolean
);
ALTER TABLE public.uses OWNER TO anchoreengine;
ALTER TABLE ONLY public.oauth2_clients ALTER COLUMN id SET DEFAULT nextval('public.oauth2_clients_id_seq'::egclass);
ALTER TABLE ONLY public.oauth2_tokens ALTER COLUMN id SET DEFAULT nextval('public.oauth2_tokens_id_seq'::egclass);
ALTER TABLE ONLY public.queue ALTER COLUMN "queueId" SET DEFAULT nextval('public."queue_queueId_seq"'::egclass);
ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::egclass);
ALTER TABLE ONLY public.account_uses
    ADD CONSTRAINT account_uses_pkey PRIMARY KEY (username);
ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (name);
ALTER TABLE ONLY public.anchoe
    ADD CONSTRAINT anchoe_pkey PRIMARY KEY (service_version, db_version);
ALTER TABLE ONLY public.achive_document
    ADD CONSTRAINT achive_document_pkey PRIMARY KEY (bucket, "archiveId", "userId", "documentName");
ALTER TABLE ONLY public.achive_metadata
    ADD CONSTRAINT achive_metadata_pkey PRIMARY KEY (bucket, "archiveId", "userId", "documentName");
ALTER TABLE ONLY public.achive_migration_tasks
    ADD CONSTRAINT achive_migration_tasks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.catalog_achive_transition_history
    ADD CONSTRAINT catalog_achive_transition_history_pkey PRIMARY KEY (transition_task_id, account, rule_id, image_digest, transition);
ALTER TABLE ONLY public.catalog_achive_transition_rules
    ADD CONSTRAINT catalog_achive_transition_rules_pkey PRIMARY KEY (account, rule_id);
ALTER TABLE ONLY public.catalog_achived_images_docker
    ADD CONSTRAINT catalog_achived_images_docker_pkey PRIMARY KEY (account, "imageDigest", registry, repository, tag);
ALTER TABLE ONLY public.catalog_achived_images
    ADD CONSTRAINT catalog_achived_images_pkey PRIMARY KEY (account, "imageDigest");
ALTER TABLE ONLY public.catalog_image_docke
    ADD CONSTRAINT catalog_image_docke_pkey PRIMARY KEY ("imageDigest", "userId", registry, repo, tag);
ALTER TABLE ONLY public.catalog_image
    ADD CONSTRAINT catalog_image_pkey PRIMARY KEY ("imageDigest", "useId");
ALTER TABLE ONLY public.disto_mappings
    ADD CONSTRAINT disto_mappings_pkey PRIMARY KEY (from_distro);
ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (geneated_uuid);
ALTER TABLE ONLY public.feed_data_cpe_vulneabilities
    ADD CONSTRAINT feed_data_cpe_vulneabilities_pkey PRIMARY KEY (feed_name, namespace_name, vulnerability_id, severity, cpetype, vendor, name, version, update, meta);
ALTER TABLE ONLY public.feed_data_cpev2_vulneabilities
    ADD CONSTRAINT feed_data_cpev2_vulneabilities_pkey PRIMARY KEY (feed_name, namespace_name, vulnerability_id, part, vendor, product, version, update, edition, language, sw_edition, target_sw, target_hw, other);
ALTER TABLE ONLY public.feed_data_gem_packages
    ADD CONSTRAINT feed_data_gem_packages_pkey PRIMARY KEY (name);
ALTER TABLE ONLY public.feed_data_npm_packages
    ADD CONSTRAINT feed_data_npm_packages_pkey PRIMARY KEY (name);
ALTER TABLE ONLY public.feed_data_nvd_vulneabilities
    ADD CONSTRAINT feed_data_nvd_vulneabilities_pkey PRIMARY KEY (name, namespace_name, severity);
ALTER TABLE ONLY public.feed_data_nvdv2_vulneabilities
    ADD CONSTRAINT feed_data_nvdv2_vulneabilities_pkey PRIMARY KEY (name, namespace_name);
ALTER TABLE ONLY public.feed_data_vulndb_cpes
    ADD CONSTRAINT feed_data_vulndb_cpes_pkey PRIMARY KEY (feed_name, namespace_name, vulneability_id, part, vendor, product, version, update, edition, language, sw_edition, target_sw, target_hw, other, is_affected);
ALTER TABLE ONLY public.feed_data_vulndb_vulneabilities
    ADD CONSTRAINT feed_data_vulndb_vulneabilities_pkey PRIMARY KEY (name, namespace_name);
ALTER TABLE ONLY public.feed_data_vulneabilities_fixed_artifacts
    ADD CONSTRAINT feed_data_vulneabilities_fixed_artifacts_pkey PRIMARY KEY (vulnerability_id, namespace_name, name, version);
ALTER TABLE ONLY public.feed_data_vulneabilities
    ADD CONSTRAINT feed_data_vulneabilities_pkey PRIMARY KEY (id, namespace_name);
ALTER TABLE ONLY public.feed_data_vulneabilities_vulnerable_artifacts
    ADD CONSTRAINT feed_data_vulneabilities_vulnerable_artifacts_pkey PRIMARY KEY (vulnerability_id, namespace_name, name, version);
ALTER TABLE ONLY public.feed_goup_data
    ADD CONSTRAINT feed_goup_data_pkey PRIMARY KEY (feed, "group", id);
ALTER TABLE ONLY public.feed_goups
    ADD CONSTRAINT feed_goups_pkey PRIMARY KEY (name, feed_name);
ALTER TABLE ONLY public.feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (name);
ALTER TABLE ONLY public.image_analysis_atifacts
    ADD CONSTRAINT image_analysis_atifacts_pkey PRIMARY KEY (image_id, image_user_id, analyzer_id, analyzer_artifact, analyzer_type, artifact_key);
ALTER TABLE ONLY public.image_cpes
    ADD CONSTRAINT image_cpes_pkey PRIMARY KEY (image_use_id, image_id, pkg_type, pkg_path, cpetype, vendor, name, version, update, meta);
ALTER TABLE ONLY public.image_fs_analysis_dump
    ADD CONSTRAINT image_fs_analysis_dump_pkey PRIMARY KEY (image_id, image_use_id);
ALTER TABLE ONLY public.image_gems
    ADD CONSTRAINT image_gems_pkey PRIMARY KEY (image_use_id, image_id, path_hash);
ALTER TABLE ONLY public.image_npms
    ADD CONSTRAINT image_npms_pkey PRIMARY KEY (image_use_id, image_id, path_hash);
ALTER TABLE ONLY public.image_package_db_enties
    ADD CONSTRAINT image_package_db_enties_pkey PRIMARY KEY (image_id, image_user_id, pkg_name, pkg_version, pkg_type, pkg_arch, pkg_path, file_path);
ALTER TABLE ONLY public.image_package_vulneabilities
    ADD CONSTRAINT image_package_vulneabilities_pkey PRIMARY KEY (pkg_user_id, pkg_image_id, pkg_name, pkg_version, pkg_type, pkg_arch, pkg_path, vulnerability_id);
ALTER TABLE ONLY public.image_packages
    ADD CONSTRAINT image_packages_pkey PRIMARY KEY (image_id, image_use_id, name, version, pkg_type, arch, pkg_path);
ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id, use_id);
ALTER TABLE ONLY public.leases
    ADD CONSTRAINT leases_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.oauth2_clients
    ADD CONSTRAINT oauth2_clients_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_access_token_key UNIQUE (access_token);
ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.object_stoage
    ADD CONSTRAINT object_stoage_pkey PRIMARY KEY ("userId", bucket, key, version);
ALTER TABLE ONLY public.policy_bundle
    ADD CONSTRAINT policy_bundle_pkey PRIMARY KEY ("policyId", "useId");
ALTER TABLE ONLY public.policy_engine_evaluation_cache
    ADD CONSTRAINT policy_engine_evaluation_cache_pkey PRIMARY KEY (use_id, image_id, eval_tag, bundle_id, bundle_digest);
ALTER TABLE ONLY public.policy_eval
    ADD CONSTRAINT policy_eval_pkey PRIMARY KEY ("useId", "imageDigest", tag, "policyId", final_action, created_at);
ALTER TABLE ONLY public.queue
    ADD CONSTRAINT queue_pkey PRIMARY KEY ("queueId", "useId", "queueName");
ALTER TABLE ONLY public.queuemeta
    ADD CONSTRAINT queuemeta_pkey PRIMARY KEY ("queueName", "useId");
ALTER TABLE ONLY public.queues
    ADD CONSTRAINT queues_pkey PRIMARY KEY ("queueId", "useId", "dataId");
ALTER TABLE ONLY public.egistries
    ADD CONSTRAINT egistries_pkey PRIMARY KEY (registry, "userId");
ALTER TABLE ONLY public.sevices
    ADD CONSTRAINT sevices_pkey PRIMARY KEY (hostid, servicename);
ALTER TABLE ONLY public.subsciptions
    ADD CONSTRAINT subsciptions_pkey PRIMARY KEY (subscription_id, "userId", subscription_type, subscription_key);
ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.use_access_credentials
    ADD CONSTRAINT use_access_credentials_pkey PRIMARY KEY (username, type);
ALTER TABLE ONLY public.uses
    ADD CONSTRAINT uses_pkey PRIMARY KEY ("userId");
CREATE INDEX idx_gem_seq ON public.image_gems USING btee (seq_id);
CREATE INDEX idx_npm_seq ON public.image_npms USING btee (seq_id);
CREATE INDEX ix_account_uses_account_name ON public.account_users USING btree (account_name);
CREATE UNIQUE INDEX ix_account_uses_uuid ON public.account_users USING btree (uuid);
CREATE INDEX ix_feed_data_cpe_vulneabilities_fk ON public.feed_data_cpe_vulnerabilities USING btree (vulnerability_id, namespace_name, severity);
CREATE INDEX ix_feed_data_cpe_vulneabilities_name_version ON public.feed_data_cpe_vulnerabilities USING btree (name, version);
CREATE INDEX ix_feed_data_cpev2_vulneabilities_fk ON public.feed_data_cpev2_vulnerabilities USING btree (vulnerability_id, namespace_name);
CREATE INDEX ix_feed_data_cpev2_vulneabilities_name_version ON public.feed_data_cpev2_vulnerabilities USING btree (product, version);
CREATE INDEX ix_feed_data_nvdv2_vulneabilities_severity ON public.feed_data_nvdv2_vulnerabilities USING btree (severity);
CREATE INDEX ix_feed_data_vulndb_affected_cpes_fk ON public.feed_data_vulndb_cpes USING btee (vulnerability_id, namespace_name);
CREATE INDEX ix_feed_data_vulndb_affected_cpes_poduct_version ON public.feed_data_vulndb_cpes USING btree (product, version);
CREATE INDEX ix_feed_data_vulndb_vulneabilities_severity ON public.feed_data_vulndb_vulnerabilities USING btree (severity);
CREATE INDEX ix_image_cpe_use_img ON public.image_cpes USING btree (image_id, image_user_id);
CREATE INDEX ix_image_package_distonamespace ON public.image_packages USING btree (name, version, distro_name, distro_version, normalized_src_pkg);
CREATE INDEX ix_level ON public.events USING btee (level);
CREATE INDEX ix_oauth2_clients_client_id ON public.oauth2_clients USING btee (client_id);
CREATE INDEX ix_oauth2_tokens_efresh_token ON public.oauth2_tokens USING btree (refresh_token);
CREATE INDEX ix_esource_id ON public.events USING btree (resource_id);
CREATE INDEX ix_esource_type ON public.events USING btree (resource_type);
CREATE INDEX ix_esource_user_id ON public.events USING btree (resource_user_id);
CREATE INDEX ix_souce_hostid ON public.events USING btree (source_hostid);
CREATE INDEX ix_souce_servicename ON public.events USING btree (source_servicename);
CREATE INDEX ix_timestamp ON public.events USING btee ("timestamp" DESC);
CREATE INDEX ix_type ON public.events USING btee (type);
ALTER TABLE ONLY public.account_uses
    ADD CONSTRAINT account_uses_account_name_fkey FOREIGN KEY (account_name) REFERENCES public.accounts(name);
ALTER TABLE ONLY public.achive_migration_tasks
    ADD CONSTRAINT achive_migration_tasks_id_fkey FOREIGN KEY (id) REFERENCES public.tasks(id);
ALTER TABLE ONLY public.feed_data_cpe_vulneabilities
    ADD CONSTRAINT feed_data_cpe_vulneabilities_vulnerability_id_fkey FOREIGN KEY (vulnerability_id, namespace_name, severity) REFERENCES public.feed_data_nvd_vulnerabilities(name, namespace_name, severity);
ALTER TABLE ONLY public.feed_data_cpev2_vulneabilities
    ADD CONSTRAINT feed_data_cpev2_vulneabilities_vulnerability_id_fkey FOREIGN KEY (vulnerability_id, namespace_name) REFERENCES public.feed_data_nvdv2_vulnerabilities(name, namespace_name);
ALTER TABLE ONLY public.feed_data_vulndb_cpes
    ADD CONSTRAINT feed_data_vulndb_cpes_vulneability_id_fkey FOREIGN KEY (vulnerability_id, namespace_name) REFERENCES public.feed_data_vulndb_vulnerabilities(name, namespace_name);
ALTER TABLE ONLY public.feed_data_vulneabilities_fixed_artifacts
    ADD CONSTRAINT feed_data_vulneabilities_fixed_artifacts_vulnerability_id_fkey FOREIGN KEY (vulnerability_id, namespace_name) REFERENCES public.feed_data_vulnerabilities(id, namespace_name);
ALTER TABLE ONLY public.feed_data_vulneabilities_vulnerable_artifacts
    ADD CONSTRAINT feed_data_vulneabilities_vulnerable_arti_vulnerability_id_fkey FOREIGN KEY (vulnerability_id, namespace_name) REFERENCES public.feed_data_vulnerabilities(id, namespace_name);
ALTER TABLE ONLY public.feed_goups
    ADD CONSTRAINT feed_goups_feed_name_fkey FOREIGN KEY (feed_name) REFERENCES public.feeds(name);
ALTER TABLE ONLY public.image_analysis_atifacts
    ADD CONSTRAINT image_analysis_atifacts_image_id_fkey FOREIGN KEY (image_id, image_user_id) REFERENCES public.images(id, user_id);
ALTER TABLE ONLY public.image_cpes
    ADD CONSTRAINT image_cpes_image_id_fkey FOREIGN KEY (image_id, image_use_id) REFERENCES public.images(id, user_id);
ALTER TABLE ONLY public.image_fs_analysis_dump
    ADD CONSTRAINT image_fs_analysis_dump_image_id_fkey FOREIGN KEY (image_id, image_use_id) REFERENCES public.images(id, user_id);
ALTER TABLE ONLY public.image_gems
    ADD CONSTRAINT image_gems_image_id_fkey FOREIGN KEY (image_id, image_use_id) REFERENCES public.images(id, user_id);
ALTER TABLE ONLY public.image_npms
    ADD CONSTRAINT image_npms_image_id_fkey FOREIGN KEY (image_id, image_use_id) REFERENCES public.images(id, user_id);
ALTER TABLE ONLY public.image_package_db_enties
    ADD CONSTRAINT image_package_db_enties_image_id_fkey FOREIGN KEY (image_id, image_user_id, pkg_name, pkg_version, pkg_type, pkg_arch, pkg_path) REFERENCES public.image_packages(image_id, image_user_id, name, version, pkg_type, arch, pkg_path);
ALTER TABLE ONLY public.image_package_vulneabilities
    ADD CONSTRAINT image_package_vulneabilities_pkg_image_id_fkey FOREIGN KEY (pkg_image_id, pkg_user_id, pkg_name, pkg_version, pkg_type, pkg_arch, pkg_path) REFERENCES public.image_packages(image_id, image_user_id, name, version, pkg_type, arch, pkg_path);
ALTER TABLE ONLY public.image_package_vulneabilities
    ADD CONSTRAINT image_package_vulneabilities_vulnerability_id_fkey FOREIGN KEY (vulnerability_id, vulnerability_namespace_name) REFERENCES public.feed_data_vulnerabilities(id, namespace_name);
ALTER TABLE ONLY public.image_packages
    ADD CONSTRAINT image_packages_image_id_fkey FOREIGN KEY (image_id, image_use_id) REFERENCES public.images(id, user_id);
ALTER TABLE ONLY public.use_access_credentials
    ADD CONSTRAINT use_access_credentials_username_fkey FOREIGN KEY (username) REFERENCES public.account_users(username);
