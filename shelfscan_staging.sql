--
-- PostgreSQL database dump
--

-- Dumped from database version 17.7
-- Dumped by pg_dump version 17.4

-- Started on 2026-02-13 00:52:18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 9 (class 2615 OID 604173)
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA drizzle;


ALTER SCHEMA drizzle OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 16572)
-- Name: google_vacuum_mgmt; Type: SCHEMA; Schema: -; Owner: cloudsqladmin
--

CREATE SCHEMA google_vacuum_mgmt;


ALTER SCHEMA google_vacuum_mgmt OWNER TO cloudsqladmin;

--
-- TOC entry 2 (class 3079 OID 16573)
-- Name: google_vacuum_mgmt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS google_vacuum_mgmt WITH SCHEMA google_vacuum_mgmt;


--
-- TOC entry 6331 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION google_vacuum_mgmt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION google_vacuum_mgmt IS 'extension for assistive operational tooling';


--
-- TOC entry 3 (class 3079 OID 604174)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 6332 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- TOC entry 4 (class 3079 OID 605257)
-- Name: postgis_raster; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_raster WITH SCHEMA public;


--
-- TOC entry 6333 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION postgis_raster; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_raster IS 'PostGIS raster types and functions';


--
-- TOC entry 2263 (class 1247 OID 605819)
-- Name: access_to_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.access_to_types AS ENUM (
    'roles',
    'employees',
    'surveys',
    'sku',
    'shops',
    'special_access',
    'schedule_visits',
    'planogram'
);


ALTER TYPE public.access_to_types OWNER TO postgres;

--
-- TOC entry 2266 (class 1247 OID 605836)
-- Name: access_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.access_types AS ENUM (
    'full_access',
    'view_access',
    'no_access'
);


ALTER TYPE public.access_types OWNER TO postgres;

--
-- TOC entry 2269 (class 1247 OID 605844)
-- Name: assigned_survey_reason_logs_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.assigned_survey_reason_logs_status_types AS ENUM (
    'NO_LOCATION_PROVIDED',
    'LOCATION_PROVIDED_NOT_UPDATED',
    'LOCATION_PROVIDED_UPDATED',
    'LOCATION_PROVIDED_REJECTED'
);


ALTER TYPE public.assigned_survey_reason_logs_status_types OWNER TO postgres;

--
-- TOC entry 2272 (class 1247 OID 605854)
-- Name: assigned_survey_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.assigned_survey_status_types AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'cancelled',
    'missed',
    'blocked'
);


ALTER TYPE public.assigned_survey_status_types OWNER TO postgres;

--
-- TOC entry 2275 (class 1247 OID 605868)
-- Name: bulk_upload_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.bulk_upload_status AS ENUM (
    'preparing',
    'queued',
    'processing',
    'paused',
    'completed',
    'failed',
    'stopped'
);


ALTER TYPE public.bulk_upload_status OWNER TO postgres;

--
-- TOC entry 2278 (class 1247 OID 605884)
-- Name: collected_image_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.collected_image_status_types AS ENUM (
    'selected',
    'rejected'
);


ALTER TYPE public.collected_image_status_types OWNER TO postgres;

--
-- TOC entry 2281 (class 1247 OID 605890)
-- Name: cooler_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.cooler_status AS ENUM (
    'active',
    'deleted'
);


ALTER TYPE public.cooler_status OWNER TO postgres;

--
-- TOC entry 2284 (class 1247 OID 605896)
-- Name: error_image_inputs_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.error_image_inputs_status AS ENUM (
    'pending',
    'corrected'
);


ALTER TYPE public.error_image_inputs_status OWNER TO postgres;

--
-- TOC entry 2287 (class 1247 OID 605902)
-- Name: feedback_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.feedback_status_types AS ENUM (
    'no_feedback',
    'on_review',
    'rejected',
    'accepted'
);


ALTER TYPE public.feedback_status_types OWNER TO postgres;

--
-- TOC entry 2290 (class 1247 OID 605912)
-- Name: gender_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender_types AS ENUM (
    'male',
    'female',
    'other',
    'prefer_not_to_say'
);


ALTER TYPE public.gender_types OWNER TO postgres;

--
-- TOC entry 2293 (class 1247 OID 605922)
-- Name: geofencing_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.geofencing_types AS ENUM (
    'no_alert',
    'soft_alert',
    'hard_alert'
);


ALTER TYPE public.geofencing_types OWNER TO postgres;

--
-- TOC entry 2296 (class 1247 OID 605930)
-- Name: image_from_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.image_from_types AS ENUM (
    'recognition',
    'collection'
);


ALTER TYPE public.image_from_types OWNER TO postgres;

--
-- TOC entry 2299 (class 1247 OID 605936)
-- Name: portal_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.portal_types AS ENUM (
    'web_portal',
    'mobile_portal'
);


ALTER TYPE public.portal_types OWNER TO postgres;

--
-- TOC entry 2302 (class 1247 OID 605942)
-- Name: question_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.question_types AS ENUM (
    'short_answer',
    'long_answer',
    'multiple_choice',
    'checkbox',
    'location',
    'number',
    'email',
    'phone',
    'link',
    'date',
    'time',
    'rating'
);


ALTER TYPE public.question_types OWNER TO postgres;

--
-- TOC entry 2305 (class 1247 OID 605968)
-- Name: shop_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.shop_status_types AS ENUM (
    'active',
    'deleted'
);


ALTER TYPE public.shop_status_types OWNER TO postgres;

--
-- TOC entry 2308 (class 1247 OID 605974)
-- Name: sku_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sku_status_types AS ENUM (
    'pending',
    'draft',
    'active',
    'in_progress',
    'completed',
    'cancelled',
    'rejected',
    'deleted'
);


ALTER TYPE public.sku_status_types OWNER TO postgres;

--
-- TOC entry 2311 (class 1247 OID 605992)
-- Name: special_access_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.special_access_types AS ENUM (
    'allow',
    'deny'
);


ALTER TYPE public.special_access_types OWNER TO postgres;

--
-- TOC entry 2314 (class 1247 OID 605998)
-- Name: survey_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.survey_status_types AS ENUM (
    'active',
    'deleted'
);


ALTER TYPE public.survey_status_types OWNER TO postgres;

--
-- TOC entry 2317 (class 1247 OID 606004)
-- Name: thumbnail_views; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.thumbnail_views AS ENUM (
    'front',
    'back',
    'left',
    'right',
    'top',
    'bottom',
    'front_top_left',
    'front_top_right',
    'front_bottom_left',
    'front_bottom_right',
    'back_top_left',
    'back_top_right',
    'back_bottom_left',
    'back_bottom_right'
);


ALTER TYPE public.thumbnail_views OWNER TO postgres;

--
-- TOC entry 2320 (class 1247 OID 606034)
-- Name: user_status_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_status_types AS ENUM (
    'active',
    'inactive',
    'deleted'
);


ALTER TYPE public.user_status_types OWNER TO postgres;

--
-- TOC entry 2323 (class 1247 OID 606042)
-- Name: user_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_types AS ENUM (
    'superAdmin',
    'organisationHead',
    'employee'
);


ALTER TYPE public.user_types OWNER TO postgres;

--
-- TOC entry 2326 (class 1247 OID 606050)
-- Name: visit_frequency_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.visit_frequency_types AS ENUM (
    'fortnightly',
    'weekly'
);


ALTER TYPE public.visit_frequency_types OWNER TO postgres;

--
-- TOC entry 647 (class 1255 OID 606055)
-- Name: update_shop_key(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_shop_key() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.key :=
      COALESCE(NEW.organisation_id::text, '') || '|' ||
      COALESCE(NEW.route_id::text, '') || '|' ||
      COALESCE(NEW.store_name::text, '') || '|' ||
      COALESCE(NEW.geographic_location::text, '') || '|' ||
      COALESCE(NEW.company_shop_id::text, '') || '|' ||
      COALESCE(NEW.status::text, 'active');
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_shop_key() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 237 (class 1259 OID 606056)
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: postgres
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


ALTER TABLE drizzle.__drizzle_migrations OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 606061)
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: postgres
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 6334 (class 0 OID 0)
-- Dependencies: 238
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: postgres
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- TOC entry 239 (class 1259 OID 606062)
-- Name: add_emp_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.add_emp_roles (
    id integer NOT NULL,
    role_access_id integer,
    special_access_id integer,
    role_id character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.add_emp_roles OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 606069)
-- Name: add_emp_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.add_emp_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.add_emp_roles_id_seq OWNER TO postgres;

--
-- TOC entry 6336 (class 0 OID 0)
-- Dependencies: 240
-- Name: add_emp_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.add_emp_roles_id_seq OWNED BY public.add_emp_roles.id;


--
-- TOC entry 241 (class 1259 OID 606070)
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    company_employee_id character varying(2500),
    admin_id character varying(2500) NOT NULL,
    manager_id integer,
    organisation_id integer NOT NULL,
    role_id integer,
    username character varying(2500),
    password character varying(2500),
    name character varying(2500),
    short_name character varying(2500),
    phone_number character varying(2500),
    gender public.gender_types DEFAULT 'prefer_not_to_say'::public.gender_types,
    profile_img character varying(2500),
    email character varying(2500),
    status public.user_status_types DEFAULT 'active'::public.user_status_types,
    is_super_admin boolean DEFAULT false,
    is_organisation_head boolean DEFAULT false,
    user_type public.user_types DEFAULT 'employee'::public.user_types,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    web_tour_guide_watch boolean DEFAULT false,
    mobile_tour_guide_watch boolean DEFAULT false,
    org_node_id integer
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 606084)
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO postgres;

--
-- TOC entry 6338 (class 0 OID 0)
-- Dependencies: 242
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- TOC entry 243 (class 1259 OID 606085)
-- Name: assigned_survey_reason_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assigned_survey_reason_logs (
    id integer NOT NULL,
    assigned_survey_id integer NOT NULL,
    reason character varying(2500) NOT NULL,
    images jsonb DEFAULT 'null'::jsonb,
    location jsonb,
    created_at timestamp without time zone DEFAULT now(),
    status public.assigned_survey_reason_logs_status_types DEFAULT 'NO_LOCATION_PROVIDED'::public.assigned_survey_reason_logs_status_types
);


ALTER TABLE public.assigned_survey_reason_logs OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 606093)
-- Name: assigned_survey_reason_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assigned_survey_reason_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assigned_survey_reason_logs_id_seq OWNER TO postgres;

--
-- TOC entry 6340 (class 0 OID 0)
-- Dependencies: 244
-- Name: assigned_survey_reason_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assigned_survey_reason_logs_id_seq OWNED BY public.assigned_survey_reason_logs.id;


--
-- TOC entry 245 (class 1259 OID 606094)
-- Name: assigned_surveys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assigned_surveys (
    id integer NOT NULL,
    visit_id integer,
    service_id character varying(2500) NOT NULL,
    admin_id integer,
    surveyor_id integer,
    shop_id integer,
    organisation_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    survey_id integer,
    survey_assigned boolean NOT NULL,
    survey_completed boolean DEFAULT false,
    survey_start_time timestamp without time zone,
    survey_end_time timestamp without time zone,
    is_survey_mandatory boolean DEFAULT false NOT NULL,
    recognition_assigned boolean NOT NULL,
    recognition_completed boolean DEFAULT false,
    recognition_start_time timestamp without time zone,
    recognition_end_time timestamp without time zone,
    recognized_cooler_data jsonb,
    recognized_shelf_data jsonb,
    collection_assigned boolean DEFAULT false NOT NULL,
    collection_completed boolean DEFAULT false,
    status public.assigned_survey_status_types DEFAULT 'pending'::public.assigned_survey_status_types,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.assigned_surveys OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 606107)
-- Name: assigned_surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assigned_surveys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assigned_surveys_id_seq OWNER TO postgres;

--
-- TOC entry 6342 (class 0 OID 0)
-- Dependencies: 246
-- Name: assigned_surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assigned_surveys_id_seq OWNED BY public.assigned_surveys.id;


--
-- TOC entry 247 (class 1259 OID 606108)
-- Name: bulk_uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bulk_uploads (
    id integer NOT NULL,
    upload_id character varying NOT NULL,
    admin_id integer,
    organisation_id integer NOT NULL,
    file_path text,
    total_rows integer,
    processed_rows integer DEFAULT 0,
    chunk_size integer DEFAULT 100,
    new_input_count integer DEFAULT 0,
    duplicate_input_count integer DEFAULT 0,
    status public.bulk_upload_status DEFAULT 'queued'::public.bulk_upload_status,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.bulk_uploads OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 606120)
-- Name: bulk_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bulk_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bulk_uploads_id_seq OWNER TO postgres;

--
-- TOC entry 6344 (class 0 OID 0)
-- Dependencies: 248
-- Name: bulk_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bulk_uploads_id_seq OWNED BY public.bulk_uploads.id;


--
-- TOC entry 249 (class 1259 OID 606121)
-- Name: coolers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coolers (
    id integer NOT NULL,
    admin_id integer,
    organisation_id integer NOT NULL,
    name character varying(2500),
    type character varying(2500),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    no_of_shelves integer DEFAULT 1,
    image character varying(2500),
    rule_image character varying(2500),
    internal_width character varying(250),
    internal_height character varying(250),
    internal_depth character varying(250),
    external_width character varying(250),
    external_height character varying(250),
    external_depth character varying(250),
    no_of_doors integer DEFAULT 1,
    layout jsonb,
    status public.cooler_status DEFAULT 'active'::public.cooler_status
);


ALTER TABLE public.coolers OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 606131)
-- Name: coolers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coolers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.coolers_id_seq OWNER TO postgres;

--
-- TOC entry 6346 (class 0 OID 0)
-- Dependencies: 250
-- Name: coolers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coolers_id_seq OWNED BY public.coolers.id;


--
-- TOC entry 251 (class 1259 OID 606132)
-- Name: counters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.counters (
    id integer NOT NULL,
    name character varying(2500),
    last_id integer DEFAULT 0
);


ALTER TABLE public.counters OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 606138)
-- Name: counters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.counters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.counters_id_seq OWNER TO postgres;

--
-- TOC entry 6348 (class 0 OID 0)
-- Dependencies: 252
-- Name: counters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.counters_id_seq OWNED BY public.counters.id;


--
-- TOC entry 253 (class 1259 OID 606139)
-- Name: daily_task_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daily_task_status (
    id integer NOT NULL,
    date character varying(2500),
    status character varying(2500),
    error text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tasks_assigned integer DEFAULT 0,
    visits_assigned integer DEFAULT 0
);


ALTER TABLE public.daily_task_status OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 606148)
-- Name: daily_task_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.daily_task_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daily_task_status_id_seq OWNER TO postgres;

--
-- TOC entry 6350 (class 0 OID 0)
-- Dependencies: 254
-- Name: daily_task_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.daily_task_status_id_seq OWNED BY public.daily_task_status.id;


--
-- TOC entry 255 (class 1259 OID 606149)
-- Name: dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboards (
    id integer NOT NULL,
    organisation_id integer NOT NULL,
    name character varying(2500),
    url text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.dashboards OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 606156)
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboards_id_seq OWNER TO postgres;

--
-- TOC entry 6352 (class 0 OID 0)
-- Dependencies: 256
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;


--
-- TOC entry 257 (class 1259 OID 606157)
-- Name: edit_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edit_requests (
    id integer NOT NULL,
    request_id character varying(2500),
    admin_id integer,
    surveyor_id integer,
    body jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.edit_requests OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 606164)
-- Name: edit_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edit_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edit_requests_id_seq OWNER TO postgres;

--
-- TOC entry 6354 (class 0 OID 0)
-- Dependencies: 258
-- Name: edit_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edit_requests_id_seq OWNED BY public.edit_requests.id;


--
-- TOC entry 259 (class 1259 OID 606165)
-- Name: email_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_status (
    id integer NOT NULL,
    email jsonb NOT NULL,
    status character varying(2500) NOT NULL,
    info jsonb,
    error jsonb,
    recipient jsonb,
    attachments jsonb,
    subject text,
    template_name text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.email_status OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 606172)
-- Name: email_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_status_id_seq OWNER TO postgres;

--
-- TOC entry 6356 (class 0 OID 0)
-- Dependencies: 260
-- Name: email_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_status_id_seq OWNED BY public.email_status.id;


--
-- TOC entry 261 (class 1259 OID 606173)
-- Name: error_image_inputs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.error_image_inputs (
    id integer NOT NULL,
    bulk_upload_id integer,
    sku_id character varying(2500),
    shop_id character varying(2500),
    admin_id integer,
    organisation_id integer NOT NULL,
    image_url character varying(2500),
    status public.error_image_inputs_status DEFAULT 'pending'::public.error_image_inputs_status,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.error_image_inputs OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 606181)
-- Name: error_image_inputs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.error_image_inputs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.error_image_inputs_id_seq OWNER TO postgres;

--
-- TOC entry 6358 (class 0 OID 0)
-- Dependencies: 262
-- Name: error_image_inputs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.error_image_inputs_id_seq OWNED BY public.error_image_inputs.id;


--
-- TOC entry 263 (class 1259 OID 606182)
-- Name: image_check_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_check_result (
    id integer NOT NULL,
    assigned_survey_id integer,
    admin_id integer,
    organisation_id integer NOT NULL,
    image character varying(2500),
    dimensions jsonb,
    metadata jsonb,
    pip_access boolean DEFAULT true,
    full_frame_detection boolean DEFAULT true,
    is_real_pic boolean DEFAULT true NOT NULL,
    is_full_frame boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.image_check_result OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 606193)
-- Name: image_check_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_check_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_check_result_id_seq OWNER TO postgres;

--
-- TOC entry 6362 (class 0 OID 0)
-- Dependencies: 264
-- Name: image_check_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_check_result_id_seq OWNED BY public.image_check_result.id;


--
-- TOC entry 265 (class 1259 OID 606194)
-- Name: image_collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_collections (
    id integer NOT NULL,
    admin_id integer,
    surveyor_id integer,
    shop_id integer,
    service_id integer,
    metadata jsonb,
    photos_taken jsonb,
    status public.collected_image_status_types DEFAULT 'selected'::public.collected_image_status_types,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    organisation_id integer,
    feedback_metadata jsonb,
    feedback_status public.feedback_status_types DEFAULT 'no_feedback'::public.feedback_status_types,
    thumb jsonb,
    image_from public.image_from_types DEFAULT 'recognition'::public.image_from_types,
    cooler_id integer,
    planogram_id integer,
    report character varying(2500)
);


ALTER TABLE public.image_collections OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 606204)
-- Name: image_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_collections_id_seq OWNER TO postgres;

--
-- TOC entry 6364 (class 0 OID 0)
-- Dependencies: 266
-- Name: image_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_collections_id_seq OWNED BY public.image_collections.id;


--
-- TOC entry 267 (class 1259 OID 606205)
-- Name: image_container_brand_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_container_brand_shares (
    id integer NOT NULL,
    image_collection_id integer,
    brand_name character varying(255) NOT NULL,
    products_count integer DEFAULT 0,
    facing_count integer DEFAULT 0,
    percent_share double precision DEFAULT 0,
    percent_share_without_es double precision DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.image_container_brand_shares OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 606214)
-- Name: image_container_brand_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_container_brand_shares_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_container_brand_shares_id_seq OWNER TO postgres;

--
-- TOC entry 6366 (class 0 OID 0)
-- Dependencies: 268
-- Name: image_container_brand_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_container_brand_shares_id_seq OWNED BY public.image_container_brand_shares.id;


--
-- TOC entry 269 (class 1259 OID 606215)
-- Name: image_container_doors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_container_doors (
    id integer NOT NULL,
    image_collection_id integer,
    image_container_id integer,
    name character varying(255),
    door_visible boolean DEFAULT false,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.image_container_doors OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 606223)
-- Name: image_container_doors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_container_doors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_container_doors_id_seq OWNER TO postgres;

--
-- TOC entry 6368 (class 0 OID 0)
-- Dependencies: 270
-- Name: image_container_doors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_container_doors_id_seq OWNED BY public.image_container_doors.id;


--
-- TOC entry 271 (class 1259 OID 606224)
-- Name: image_container_product_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_container_product_shares (
    id integer NOT NULL,
    image_collection_id integer,
    brand_share_id integer,
    product_name character varying(255) NOT NULL,
    sku_code character varying(255),
    owner character varying(20),
    actual_facing integer DEFAULT 0,
    planned_facing integer DEFAULT 0,
    facing_gap integer DEFAULT 0,
    percent_of_brand double precision DEFAULT 0,
    relative_share double precision DEFAULT 0,
    compliance double precision DEFAULT 0,
    compliance_status character varying(255),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.image_container_product_shares OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 606237)
-- Name: image_container_product_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_container_product_shares_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_container_product_shares_id_seq OWNER TO postgres;

--
-- TOC entry 6370 (class 0 OID 0)
-- Dependencies: 272
-- Name: image_container_product_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_container_product_shares_id_seq OWNED BY public.image_container_product_shares.id;


--
-- TOC entry 273 (class 1259 OID 606238)
-- Name: image_container_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_container_products (
    id integer NOT NULL,
    image_collection_id integer,
    image_container_section_id integer,
    name character varying(255),
    "position" integer,
    sku_code character varying(255),
    stack_size integer,
    confidence character varying(255),
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    shelf integer,
    owner character varying(20),
    area double precision,
    ppm boolean DEFAULT false,
    ptm boolean DEFAULT false,
    ptm_reason character varying(255),
    ptm_suggestion text,
    ppm_metadata jsonb
);


ALTER TABLE public.image_container_products OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 606247)
-- Name: image_container_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_container_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_container_products_id_seq OWNER TO postgres;

--
-- TOC entry 6372 (class 0 OID 0)
-- Dependencies: 274
-- Name: image_container_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_container_products_id_seq OWNED BY public.image_container_products.id;


--
-- TOC entry 275 (class 1259 OID 606248)
-- Name: image_container_sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_container_sections (
    id integer NOT NULL,
    image_collection_id integer,
    image_container_door_id integer,
    name character varying(255),
    "position" integer,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    area double precision,
    empty_space_area double precision,
    own_products_count integer DEFAULT 0,
    competitor_products_count integer DEFAULT 0,
    other_products_count integer DEFAULT 0,
    percent_empty_space double precision DEFAULT 0,
    percent_area_used double precision DEFAULT 0,
    osa_without_es double precision DEFAULT 0,
    osa_considering_es double precision DEFAULT 0,
    competitor_percent_considering_es double precision DEFAULT 0,
    other_percent_considering_es double precision DEFAULT 0
);


ALTER TABLE public.image_container_sections OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 606264)
-- Name: image_container_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_container_sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_container_sections_id_seq OWNER TO postgres;

--
-- TOC entry 6374 (class 0 OID 0)
-- Dependencies: 276
-- Name: image_container_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_container_sections_id_seq OWNED BY public.image_container_sections.id;


--
-- TOC entry 277 (class 1259 OID 606265)
-- Name: image_container_stacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_container_stacks (
    id integer NOT NULL,
    image_collection_id integer,
    image_container_product_id integer,
    name character varying(255),
    "position" integer,
    sku_code character varying(255),
    stack_size integer,
    confidence character varying(255),
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    shelf integer,
    owner character varying(20),
    ppm boolean DEFAULT false,
    ptm boolean DEFAULT false,
    ptm_reason character varying(255),
    ptm_suggestion text,
    ppm_metadata jsonb
);


ALTER TABLE public.image_container_stacks OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 606274)
-- Name: image_container_stacks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_container_stacks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_container_stacks_id_seq OWNER TO postgres;

--
-- TOC entry 6376 (class 0 OID 0)
-- Dependencies: 278
-- Name: image_container_stacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_container_stacks_id_seq OWNED BY public.image_container_stacks.id;


--
-- TOC entry 279 (class 1259 OID 606275)
-- Name: image_containers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_containers (
    id integer NOT NULL,
    image_collection_id integer,
    image_metadata_id integer,
    name character varying(255),
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    percent_empty_space double precision DEFAULT 0,
    percent_area_used double precision DEFAULT 0,
    ptm_count integer DEFAULT 0,
    ppm_count integer DEFAULT 0,
    ptmp double precision DEFAULT 0,
    ppmp double precision DEFAULT 0,
    own_products_count integer DEFAULT 0,
    competitor_products_count integer DEFAULT 0,
    other_products_count integer DEFAULT 0,
    products_detected integer DEFAULT 0,
    osa double precision DEFAULT 0,
    oscp double precision DEFAULT 0,
    osop double precision DEFAULT 0,
    compliance double precision DEFAULT 0
);


ALTER TABLE public.image_containers OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 606296)
-- Name: image_containers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_containers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_containers_id_seq OWNER TO postgres;

--
-- TOC entry 6378 (class 0 OID 0)
-- Dependencies: 280
-- Name: image_containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_containers_id_seq OWNED BY public.image_containers.id;


--
-- TOC entry 281 (class 1259 OID 606297)
-- Name: image_metadatas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image_metadatas (
    id integer NOT NULL,
    image_collection_id integer,
    height integer,
    width integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.image_metadatas OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 606302)
-- Name: image_metadatas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_metadatas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_metadatas_id_seq OWNER TO postgres;

--
-- TOC entry 6380 (class 0 OID 0)
-- Dependencies: 282
-- Name: image_metadatas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_metadatas_id_seq OWNED BY public.image_metadatas.id;


--
-- TOC entry 283 (class 1259 OID 606303)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    level integer,
    message text,
    stack text,
    "timestamp" timestamp with time zone,
    context jsonb,
    status character varying(2500) DEFAULT 'unchecked'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 606311)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- TOC entry 6382 (class 0 OID 0)
-- Dependencies: 284
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 285 (class 1259 OID 606312)
-- Name: models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models (
    id integer NOT NULL,
    organisation_id integer NOT NULL,
    name character varying(2500),
    url text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.models OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 606319)
-- Name: models_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.models_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.models_id_seq OWNER TO postgres;

--
-- TOC entry 6384 (class 0 OID 0)
-- Dependencies: 286
-- Name: models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.models_id_seq OWNED BY public.models.id;


--
-- TOC entry 287 (class 1259 OID 606320)
-- Name: muse_planograms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.muse_planograms (
    id integer NOT NULL,
    admin_id integer,
    cooler_id integer,
    organisation_id integer NOT NULL,
    name character varying(2500),
    image character varying(2500),
    metadata jsonb,
    status public.cooler_status DEFAULT 'active'::public.cooler_status,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.muse_planograms OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 606328)
-- Name: muse_planograms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.muse_planograms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.muse_planograms_id_seq OWNER TO postgres;

--
-- TOC entry 6386 (class 0 OID 0)
-- Dependencies: 288
-- Name: muse_planograms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.muse_planograms_id_seq OWNED BY public.muse_planograms.id;


--
-- TOC entry 289 (class 1259 OID 606329)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    notification_id character varying(2500),
    admin_id integer,
    title character varying(2500),
    message text,
    progress character varying,
    tag character varying(2500),
    details jsonb,
    read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 606337)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- TOC entry 6388 (class 0 OID 0)
-- Dependencies: 290
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 340 (class 1259 OID 772184)
-- Name: org_nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_nodes (
    id integer NOT NULL,
    organisation_id integer NOT NULL,
    parent_id integer,
    level_id integer NOT NULL,
    name character varying(500) NOT NULL,
    code character varying(100),
    path character varying(500) NOT NULL,
    role_id integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.org_nodes OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 772183)
-- Name: org_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.org_nodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.org_nodes_id_seq OWNER TO postgres;

--
-- TOC entry 6390 (class 0 OID 0)
-- Dependencies: 339
-- Name: org_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.org_nodes_id_seq OWNED BY public.org_nodes.id;


--
-- TOC entry 342 (class 1259 OID 772197)
-- Name: organisation_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation_levels (
    id integer NOT NULL,
    organisation_id integer NOT NULL,
    code character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    level_order integer NOT NULL,
    description text,
    color character varying(20),
    role_id integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.organisation_levels OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 772196)
-- Name: organisation_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organisation_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organisation_levels_id_seq OWNER TO postgres;

--
-- TOC entry 6392 (class 0 OID 0)
-- Dependencies: 341
-- Name: organisation_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organisation_levels_id_seq OWNED BY public.organisation_levels.id;


--
-- TOC entry 291 (class 1259 OID 606338)
-- Name: organisations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisations (
    id integer NOT NULL,
    organisation_id character varying(2500) NOT NULL,
    name character varying(2500) NOT NULL,
    short_name character varying(2500),
    logo_url text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type character varying(255) DEFAULT 'client'::character varying,
    pip_access boolean DEFAULT true,
    vti_access boolean DEFAULT true,
    geofencing boolean DEFAULT true,
    brand_owner_name character varying(2500),
    full_frame_detection boolean DEFAULT true
);


ALTER TABLE public.organisations OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 606350)
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organisations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organisations_id_seq OWNER TO postgres;

--
-- TOC entry 6394 (class 0 OID 0)
-- Dependencies: 292
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organisations_id_seq OWNED BY public.organisations.id;


--
-- TOC entry 293 (class 1259 OID 606351)
-- Name: planograms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planograms (
    id integer NOT NULL,
    admin_id integer,
    cooler_id integer,
    organisation_id integer NOT NULL,
    name character varying(2500),
    image character varying(2500),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    metadata jsonb,
    products jsonb,
    status public.cooler_status DEFAULT 'active'::public.cooler_status
);


ALTER TABLE public.planograms OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 606359)
-- Name: planograms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.planograms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.planograms_id_seq OWNER TO postgres;

--
-- TOC entry 6396 (class 0 OID 0)
-- Dependencies: 294
-- Name: planograms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planograms_id_seq OWNED BY public.planograms.id;


--
-- TOC entry 295 (class 1259 OID 606360)
-- Name: poc_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poc_image (
    id integer NOT NULL,
    admin_id integer,
    meta_data jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.poc_image OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 606367)
-- Name: poc_image_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poc_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.poc_image_id_seq OWNER TO postgres;

--
-- TOC entry 6398 (class 0 OID 0)
-- Dependencies: 296
-- Name: poc_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.poc_image_id_seq OWNED BY public.poc_image.id;


--
-- TOC entry 297 (class 1259 OID 606368)
-- Name: poc_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poc_images (
    id integer NOT NULL,
    admin_id integer,
    image_id integer,
    image character varying,
    meta_data jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.poc_images OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 606375)
-- Name: poc_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poc_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.poc_images_id_seq OWNER TO postgres;

--
-- TOC entry 6400 (class 0 OID 0)
-- Dependencies: 298
-- Name: poc_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.poc_images_id_seq OWNED BY public.poc_images.id;


--
-- TOC entry 299 (class 1259 OID 606376)
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    question_id character varying(2500) NOT NULL,
    survey_id integer,
    images jsonb,
    content character varying(2500) NOT NULL,
    type public.question_types DEFAULT 'short_answer'::public.question_types,
    options jsonb,
    required boolean DEFAULT false,
    status public.survey_status_types DEFAULT 'active'::public.survey_status_types,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 606386)
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questions_id_seq OWNER TO postgres;

--
-- TOC entry 6402 (class 0 OID 0)
-- Dependencies: 300
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- TOC entry 301 (class 1259 OID 606387)
-- Name: recognition_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recognition_jobs (
    id integer NOT NULL,
    job_id character varying NOT NULL,
    admin_id integer,
    planogram_id integer,
    cooler_id integer,
    assigned_surevy_id integer,
    on_cooler boolean DEFAULT false,
    image_url character varying(2500),
    compressed_image_url character varying(2500),
    status character varying(250) DEFAULT 'queued'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    error_message character varying(2500)
);


ALTER TABLE public.recognition_jobs OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 606396)
-- Name: recognition_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recognition_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recognition_jobs_id_seq OWNER TO postgres;

--
-- TOC entry 6406 (class 0 OID 0)
-- Dependencies: 302
-- Name: recognition_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recognition_jobs_id_seq OWNED BY public.recognition_jobs.id;


--
-- TOC entry 303 (class 1259 OID 606397)
-- Name: responses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.responses (
    id integer NOT NULL,
    r_id character varying(2500) NOT NULL,
    assigned_survey_id integer,
    question_id integer,
    response character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.responses OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 606404)
-- Name: responses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.responses_id_seq OWNER TO postgres;

--
-- TOC entry 6408 (class 0 OID 0)
-- Dependencies: 304
-- Name: responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.responses_id_seq OWNED BY public.responses.id;


--
-- TOC entry 305 (class 1259 OID 606405)
-- Name: roboflow_projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roboflow_projects (
    id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    project_name text NOT NULL,
    project_id text NOT NULL
);


ALTER TABLE public.roboflow_projects OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 606410)
-- Name: roboflow_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roboflow_projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roboflow_projects_id_seq OWNER TO postgres;

--
-- TOC entry 6410 (class 0 OID 0)
-- Dependencies: 306
-- Name: roboflow_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roboflow_projects_id_seq OWNED BY public.roboflow_projects.id;


--
-- TOC entry 307 (class 1259 OID 606411)
-- Name: role_accesses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_accesses (
    id integer NOT NULL,
    role_id integer,
    access_to public.access_to_types NOT NULL,
    access_type public.access_types DEFAULT 'view_access'::public.access_types,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.role_accesses OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 606417)
-- Name: role_accesses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_accesses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_accesses_id_seq OWNER TO postgres;

--
-- TOC entry 6412 (class 0 OID 0)
-- Dependencies: 308
-- Name: role_accesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_accesses_id_seq OWNED BY public.role_accesses.id;


--
-- TOC entry 309 (class 1259 OID 606418)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    role_id character varying(2500) NOT NULL,
    admin_id integer,
    organisation_id integer NOT NULL,
    name character varying(2500),
    short_name character varying(2500),
    description text,
    portal_access jsonb DEFAULT '["mobile_portal", "web_portal"]'::jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 606426)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 6414 (class 0 OID 0)
-- Dependencies: 310
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 311 (class 1259 OID 606427)
-- Name: scheduled_visits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduled_visits (
    id integer NOT NULL,
    shop_id integer NOT NULL,
    organisation_id integer NOT NULL,
    route_id character varying(2500),
    frequency public.visit_frequency_types DEFAULT 'weekly'::public.visit_frequency_types,
    monday boolean DEFAULT false NOT NULL,
    tuesday boolean DEFAULT false NOT NULL,
    wednesday boolean DEFAULT false NOT NULL,
    thursday boolean DEFAULT false NOT NULL,
    friday boolean DEFAULT false NOT NULL,
    saturday boolean DEFAULT false NOT NULL,
    sunday boolean DEFAULT false NOT NULL,
    start_date date,
    last_performed_on date,
    next_due_date date,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.scheduled_visits OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 606442)
-- Name: scheduled_visits_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scheduled_visits_new_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scheduled_visits_new_id_seq OWNER TO postgres;

--
-- TOC entry 6416 (class 0 OID 0)
-- Dependencies: 312
-- Name: scheduled_visits_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scheduled_visits_new_id_seq OWNED BY public.scheduled_visits.id;


--
-- TOC entry 313 (class 1259 OID 606443)
-- Name: shelf_ex_skus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shelf_ex_skus (
    id integer NOT NULL,
    name character varying(2500),
    code character varying(2500) NOT NULL,
    product_size character varying(2500),
    brand_owner_name character varying(2500),
    product_category character varying(2500),
    product_type character varying(2500),
    pack_category character varying(2500),
    pack_type character varying(2500),
    brand_name character varying(2500),
    sub_brand character varying(2500),
    product_width character varying(2500),
    product_height character varying(2500),
    packing_size character varying(2500),
    thumbnails jsonb DEFAULT '[]'::jsonb,
    status public.sku_status_types DEFAULT 'pending'::public.sku_status_types,
    color character varying(2500),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    product_depth character varying(2500),
    is_stackable boolean DEFAULT false
);


ALTER TABLE public.shelf_ex_skus OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 606453)
-- Name: shelf_ex_skus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shelf_ex_skus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shelf_ex_skus_id_seq OWNER TO postgres;

--
-- TOC entry 6418 (class 0 OID 0)
-- Dependencies: 314
-- Name: shelf_ex_skus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shelf_ex_skus_id_seq OWNED BY public.shelf_ex_skus.id;


--
-- TOC entry 315 (class 1259 OID 606454)
-- Name: shops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shops (
    id integer NOT NULL,
    shop_id character varying NOT NULL,
    route_id character varying(2500),
    admin_id integer,
    organisation_id integer NOT NULL,
    store_name character varying(2500) NOT NULL,
    store_image character varying(2500),
    store_address text,
    city_name character varying(2500),
    geographic_location character varying(2500),
    retailer_name character varying(2500),
    segment_name character varying(2500),
    region_name character varying(2500),
    store_type_name character varying(2500),
    created_at timestamp without time zone DEFAULT now(),
    status public.shop_status_types DEFAULT 'active'::public.shop_status_types,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    company_shop_id character varying(2500),
    latitude double precision,
    longitude double precision,
    key character varying(2500),
    unit_id integer,
    org_node_id integer
);


ALTER TABLE public.shops OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 606462)
-- Name: shops_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shops_id_seq OWNER TO postgres;

--
-- TOC entry 6420 (class 0 OID 0)
-- Dependencies: 316
-- Name: shops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shops_id_seq OWNED BY public.shops.id;


--
-- TOC entry 317 (class 1259 OID 606463)
-- Name: skus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skus (
    id integer NOT NULL,
    sku_id character varying(2500) NOT NULL,
    admin_id integer,
    organisation_id integer NOT NULL,
    name character varying(2500),
    product_size character varying(2500),
    product_code character varying(2500),
    brand_owner_name character varying(2500),
    product_category character varying(2500),
    product_type character varying(2500),
    brand_name character varying(2500),
    product_width character varying(2500),
    product_height character varying(2500),
    packing_size character varying(2500),
    sub_brand character varying(2500),
    color character varying(2500),
    status public.sku_status_types DEFAULT 'pending'::public.sku_status_types,
    review_notes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    pack_category character varying(2500),
    pack_type character varying(2500),
    shelf_ex_sku_id character varying
);


ALTER TABLE public.skus OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 606471)
-- Name: skus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skus_id_seq OWNER TO postgres;

--
-- TOC entry 6422 (class 0 OID 0)
-- Dependencies: 318
-- Name: skus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skus_id_seq OWNED BY public.skus.id;


--
-- TOC entry 319 (class 1259 OID 606472)
-- Name: special_accesses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.special_accesses (
    id integer NOT NULL,
    user_id integer,
    access_to public.access_to_types NOT NULL,
    access_type public.access_types DEFAULT 'view_access'::public.access_types,
    type public.special_access_types NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.special_accesses OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 606478)
-- Name: special_accesses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.special_accesses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.special_accesses_id_seq OWNER TO postgres;

--
-- TOC entry 6425 (class 0 OID 0)
-- Dependencies: 320
-- Name: special_accesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.special_accesses_id_seq OWNED BY public.special_accesses.id;


--
-- TOC entry 321 (class 1259 OID 606479)
-- Name: store_coolers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_coolers (
    id integer NOT NULL,
    admin_id integer,
    shop_id integer,
    cooler_id integer
);


ALTER TABLE public.store_coolers OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 606482)
-- Name: store_coolers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_coolers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.store_coolers_id_seq OWNER TO postgres;

--
-- TOC entry 6427 (class 0 OID 0)
-- Dependencies: 322
-- Name: store_coolers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_coolers_id_seq OWNED BY public.store_coolers.id;


--
-- TOC entry 323 (class 1259 OID 606483)
-- Name: store_planograms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_planograms (
    id integer NOT NULL,
    admin_id integer,
    shop_id integer,
    planogram_id integer
);


ALTER TABLE public.store_planograms OWNER TO postgres;

--
-- TOC entry 324 (class 1259 OID 606486)
-- Name: store_planograms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_planograms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.store_planograms_id_seq OWNER TO postgres;

--
-- TOC entry 6429 (class 0 OID 0)
-- Dependencies: 324
-- Name: store_planograms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_planograms_id_seq OWNED BY public.store_planograms.id;


--
-- TOC entry 325 (class 1259 OID 606487)
-- Name: surveys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.surveys (
    id integer NOT NULL,
    survey_id character varying(2500) NOT NULL,
    admin_id integer,
    organisation_id integer NOT NULL,
    description character varying(2500),
    title character varying(2500),
    status public.survey_status_types DEFAULT 'active'::public.survey_status_types,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.surveys OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 606495)
-- Name: surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.surveys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.surveys_id_seq OWNER TO postgres;

--
-- TOC entry 6431 (class 0 OID 0)
-- Dependencies: 326
-- Name: surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.surveys_id_seq OWNED BY public.surveys.id;


--
-- TOC entry 327 (class 1259 OID 606496)
-- Name: task_assignment_failures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_assignment_failures (
    id integer NOT NULL,
    admin_id integer,
    reason text,
    error text,
    date character varying(255),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.task_assignment_failures OWNER TO postgres;

--
-- TOC entry 328 (class 1259 OID 606503)
-- Name: task_assignment_failures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_assignment_failures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_assignment_failures_id_seq OWNER TO postgres;

--
-- TOC entry 6433 (class 0 OID 0)
-- Dependencies: 328
-- Name: task_assignment_failures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_assignment_failures_id_seq OWNED BY public.task_assignment_failures.id;


--
-- TOC entry 329 (class 1259 OID 606504)
-- Name: thumbnails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thumbnails (
    id integer NOT NULL,
    admin_id integer,
    sku_id character varying,
    thumbnail character varying(2500),
    type public.thumbnail_views DEFAULT 'front'::public.thumbnail_views,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.thumbnails OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 606512)
-- Name: thumbnails_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.thumbnails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.thumbnails_id_seq OWNER TO postgres;

--
-- TOC entry 6435 (class 0 OID 0)
-- Dependencies: 330
-- Name: thumbnails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.thumbnails_id_seq OWNED BY public.thumbnails.id;


--
-- TOC entry 331 (class 1259 OID 606513)
-- Name: units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.units (
    id integer NOT NULL,
    unit_code character varying(2500),
    organisation_id integer NOT NULL,
    unit_head_id integer,
    unit_name character varying(2500) NOT NULL,
    pip_access boolean DEFAULT true,
    vti_access boolean DEFAULT true,
    geofencing public.geofencing_types DEFAULT 'soft_alert'::public.geofencing_types,
    geofencing_radius integer DEFAULT 100,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    full_frame_detection boolean DEFAULT true
);


ALTER TABLE public.units OWNER TO postgres;

--
-- TOC entry 332 (class 1259 OID 606525)
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.units_id_seq OWNER TO postgres;

--
-- TOC entry 6437 (class 0 OID 0)
-- Dependencies: 332
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- TOC entry 333 (class 1259 OID 606526)
-- Name: user_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_activity (
    id integer NOT NULL,
    admin_id character varying,
    portal_type public.portal_types NOT NULL,
    page_name character varying(1000),
    page_url character varying(2000),
    details jsonb,
    browser character varying(1000),
    os character varying(500),
    screen_resolution character varying(50),
    timezone character varying(200),
    language character varying(50),
    referrer character varying(2000),
    ip character varying(100),
    server_timestamp timestamp without time zone DEFAULT now(),
    created_at timestamp without time zone DEFAULT now(),
    api_url character varying(2000),
    method character varying(10)
);


ALTER TABLE public.user_activity OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 606533)
-- Name: user_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_activity_id_seq OWNER TO postgres;

--
-- TOC entry 6439 (class 0 OID 0)
-- Dependencies: 334
-- Name: user_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_activity_id_seq OWNED BY public.user_activity.id;


--
-- TOC entry 335 (class 1259 OID 606534)
-- Name: user_routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_routes (
    id integer NOT NULL,
    admin_id integer,
    route_id character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    organisation_id integer
);


ALTER TABLE public.user_routes OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 606541)
-- Name: user_routes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_routes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_routes_id_seq OWNER TO postgres;

--
-- TOC entry 6441 (class 0 OID 0)
-- Dependencies: 336
-- Name: user_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_routes_id_seq OWNED BY public.user_routes.id;


--
-- TOC entry 337 (class 1259 OID 606542)
-- Name: visits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visits (
    id integer NOT NULL,
    visit_id character varying(2500) NOT NULL,
    visit_name character varying(2500),
    survey_id integer,
    admin_id integer,
    surveyor_id integer,
    organisation_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status public.assigned_survey_status_types DEFAULT 'pending'::public.assigned_survey_status_types,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.visits OWNER TO postgres;

--
-- TOC entry 338 (class 1259 OID 606550)
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visits_id_seq OWNER TO postgres;

--
-- TOC entry 6443 (class 0 OID 0)
-- Dependencies: 338
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visits_id_seq OWNED BY public.visits.id;


--
-- TOC entry 5592 (class 2604 OID 606551)
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: postgres
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- TOC entry 5593 (class 2604 OID 606552)
-- Name: add_emp_roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_emp_roles ALTER COLUMN id SET DEFAULT nextval('public.add_emp_roles_id_seq'::regclass);


--
-- TOC entry 5596 (class 2604 OID 606553)
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- TOC entry 5606 (class 2604 OID 606554)
-- Name: assigned_survey_reason_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_survey_reason_logs ALTER COLUMN id SET DEFAULT nextval('public.assigned_survey_reason_logs_id_seq'::regclass);


--
-- TOC entry 5610 (class 2604 OID 606555)
-- Name: assigned_surveys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys ALTER COLUMN id SET DEFAULT nextval('public.assigned_surveys_id_seq'::regclass);


--
-- TOC entry 5619 (class 2604 OID 606556)
-- Name: bulk_uploads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bulk_uploads ALTER COLUMN id SET DEFAULT nextval('public.bulk_uploads_id_seq'::regclass);


--
-- TOC entry 5627 (class 2604 OID 606557)
-- Name: coolers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coolers ALTER COLUMN id SET DEFAULT nextval('public.coolers_id_seq'::regclass);


--
-- TOC entry 5633 (class 2604 OID 606558)
-- Name: counters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counters ALTER COLUMN id SET DEFAULT nextval('public.counters_id_seq'::regclass);


--
-- TOC entry 5635 (class 2604 OID 606559)
-- Name: daily_task_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_task_status ALTER COLUMN id SET DEFAULT nextval('public.daily_task_status_id_seq'::regclass);


--
-- TOC entry 5640 (class 2604 OID 606560)
-- Name: dashboards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);


--
-- TOC entry 5643 (class 2604 OID 606561)
-- Name: edit_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_requests ALTER COLUMN id SET DEFAULT nextval('public.edit_requests_id_seq'::regclass);


--
-- TOC entry 5646 (class 2604 OID 606562)
-- Name: email_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_status ALTER COLUMN id SET DEFAULT nextval('public.email_status_id_seq'::regclass);


--
-- TOC entry 5649 (class 2604 OID 606563)
-- Name: error_image_inputs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_image_inputs ALTER COLUMN id SET DEFAULT nextval('public.error_image_inputs_id_seq'::regclass);


--
-- TOC entry 5653 (class 2604 OID 606564)
-- Name: image_check_result id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_check_result ALTER COLUMN id SET DEFAULT nextval('public.image_check_result_id_seq'::regclass);


--
-- TOC entry 5660 (class 2604 OID 606565)
-- Name: image_collections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections ALTER COLUMN id SET DEFAULT nextval('public.image_collections_id_seq'::regclass);


--
-- TOC entry 5666 (class 2604 OID 606566)
-- Name: image_container_brand_shares id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_brand_shares ALTER COLUMN id SET DEFAULT nextval('public.image_container_brand_shares_id_seq'::regclass);


--
-- TOC entry 5673 (class 2604 OID 606567)
-- Name: image_container_doors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_doors ALTER COLUMN id SET DEFAULT nextval('public.image_container_doors_id_seq'::regclass);


--
-- TOC entry 5677 (class 2604 OID 606568)
-- Name: image_container_product_shares id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_product_shares ALTER COLUMN id SET DEFAULT nextval('public.image_container_product_shares_id_seq'::regclass);


--
-- TOC entry 5686 (class 2604 OID 606569)
-- Name: image_container_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_products ALTER COLUMN id SET DEFAULT nextval('public.image_container_products_id_seq'::regclass);


--
-- TOC entry 5691 (class 2604 OID 606570)
-- Name: image_container_sections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_sections ALTER COLUMN id SET DEFAULT nextval('public.image_container_sections_id_seq'::regclass);


--
-- TOC entry 5703 (class 2604 OID 606571)
-- Name: image_container_stacks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_stacks ALTER COLUMN id SET DEFAULT nextval('public.image_container_stacks_id_seq'::regclass);


--
-- TOC entry 5708 (class 2604 OID 606572)
-- Name: image_containers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_containers ALTER COLUMN id SET DEFAULT nextval('public.image_containers_id_seq'::regclass);


--
-- TOC entry 5725 (class 2604 OID 606573)
-- Name: image_metadatas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_metadatas ALTER COLUMN id SET DEFAULT nextval('public.image_metadatas_id_seq'::regclass);


--
-- TOC entry 5728 (class 2604 OID 606574)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 5732 (class 2604 OID 606575)
-- Name: models id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models ALTER COLUMN id SET DEFAULT nextval('public.models_id_seq'::regclass);


--
-- TOC entry 5735 (class 2604 OID 606576)
-- Name: muse_planograms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muse_planograms ALTER COLUMN id SET DEFAULT nextval('public.muse_planograms_id_seq'::regclass);


--
-- TOC entry 5739 (class 2604 OID 606577)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 5844 (class 2604 OID 772187)
-- Name: org_nodes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_nodes ALTER COLUMN id SET DEFAULT nextval('public.org_nodes_id_seq'::regclass);


--
-- TOC entry 5847 (class 2604 OID 772200)
-- Name: organisation_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_levels ALTER COLUMN id SET DEFAULT nextval('public.organisation_levels_id_seq'::regclass);


--
-- TOC entry 5743 (class 2604 OID 606578)
-- Name: organisations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations ALTER COLUMN id SET DEFAULT nextval('public.organisations_id_seq'::regclass);


--
-- TOC entry 5751 (class 2604 OID 606579)
-- Name: planograms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planograms ALTER COLUMN id SET DEFAULT nextval('public.planograms_id_seq'::regclass);


--
-- TOC entry 5755 (class 2604 OID 606580)
-- Name: poc_image id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc_image ALTER COLUMN id SET DEFAULT nextval('public.poc_image_id_seq'::regclass);


--
-- TOC entry 5758 (class 2604 OID 606581)
-- Name: poc_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc_images ALTER COLUMN id SET DEFAULT nextval('public.poc_images_id_seq'::regclass);


--
-- TOC entry 5761 (class 2604 OID 606582)
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- TOC entry 5767 (class 2604 OID 606583)
-- Name: recognition_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recognition_jobs ALTER COLUMN id SET DEFAULT nextval('public.recognition_jobs_id_seq'::regclass);


--
-- TOC entry 5772 (class 2604 OID 606584)
-- Name: responses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses ALTER COLUMN id SET DEFAULT nextval('public.responses_id_seq'::regclass);


--
-- TOC entry 5775 (class 2604 OID 606585)
-- Name: roboflow_projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roboflow_projects ALTER COLUMN id SET DEFAULT nextval('public.roboflow_projects_id_seq'::regclass);


--
-- TOC entry 5776 (class 2604 OID 606586)
-- Name: role_accesses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_accesses ALTER COLUMN id SET DEFAULT nextval('public.role_accesses_id_seq'::regclass);


--
-- TOC entry 5780 (class 2604 OID 606587)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 5784 (class 2604 OID 606588)
-- Name: scheduled_visits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_visits ALTER COLUMN id SET DEFAULT nextval('public.scheduled_visits_new_id_seq'::regclass);


--
-- TOC entry 5795 (class 2604 OID 606589)
-- Name: shelf_ex_skus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelf_ex_skus ALTER COLUMN id SET DEFAULT nextval('public.shelf_ex_skus_id_seq'::regclass);


--
-- TOC entry 5801 (class 2604 OID 606590)
-- Name: shops id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops ALTER COLUMN id SET DEFAULT nextval('public.shops_id_seq'::regclass);


--
-- TOC entry 5805 (class 2604 OID 606591)
-- Name: skus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skus ALTER COLUMN id SET DEFAULT nextval('public.skus_id_seq'::regclass);


--
-- TOC entry 5809 (class 2604 OID 606592)
-- Name: special_accesses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_accesses ALTER COLUMN id SET DEFAULT nextval('public.special_accesses_id_seq'::regclass);


--
-- TOC entry 5813 (class 2604 OID 606593)
-- Name: store_coolers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_coolers ALTER COLUMN id SET DEFAULT nextval('public.store_coolers_id_seq'::regclass);


--
-- TOC entry 5814 (class 2604 OID 606594)
-- Name: store_planograms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_planograms ALTER COLUMN id SET DEFAULT nextval('public.store_planograms_id_seq'::regclass);


--
-- TOC entry 5815 (class 2604 OID 606595)
-- Name: surveys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys ALTER COLUMN id SET DEFAULT nextval('public.surveys_id_seq'::regclass);


--
-- TOC entry 5819 (class 2604 OID 606596)
-- Name: task_assignment_failures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignment_failures ALTER COLUMN id SET DEFAULT nextval('public.task_assignment_failures_id_seq'::regclass);


--
-- TOC entry 5822 (class 2604 OID 606597)
-- Name: thumbnails id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thumbnails ALTER COLUMN id SET DEFAULT nextval('public.thumbnails_id_seq'::regclass);


--
-- TOC entry 5826 (class 2604 OID 606598)
-- Name: units id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- TOC entry 5834 (class 2604 OID 606599)
-- Name: user_activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity ALTER COLUMN id SET DEFAULT nextval('public.user_activity_id_seq'::regclass);


--
-- TOC entry 5837 (class 2604 OID 606600)
-- Name: user_routes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_routes ALTER COLUMN id SET DEFAULT nextval('public.user_routes_id_seq'::regclass);


--
-- TOC entry 5840 (class 2604 OID 606601)
-- Name: visits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits ALTER COLUMN id SET DEFAULT nextval('public.visits_id_seq'::regclass);


--
-- TOC entry 5854 (class 2606 OID 766966)
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: postgres
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5856 (class 2606 OID 766968)
-- Name: add_emp_roles add_emp_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_emp_roles
    ADD CONSTRAINT add_emp_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5864 (class 2606 OID 766970)
-- Name: admins admins_admin_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_admin_id_unique UNIQUE (admin_id);


--
-- TOC entry 5866 (class 2606 OID 766972)
-- Name: admins admins_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_unique UNIQUE (email);


--
-- TOC entry 5868 (class 2606 OID 766974)
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- TOC entry 5871 (class 2606 OID 766976)
-- Name: assigned_survey_reason_logs assigned_survey_reason_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_survey_reason_logs
    ADD CONSTRAINT assigned_survey_reason_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5876 (class 2606 OID 766978)
-- Name: assigned_surveys assigned_surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_pkey PRIMARY KEY (id);


--
-- TOC entry 5878 (class 2606 OID 766980)
-- Name: assigned_surveys assigned_surveys_service_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_service_id_unique UNIQUE (service_id);


--
-- TOC entry 5881 (class 2606 OID 766983)
-- Name: bulk_uploads bulk_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bulk_uploads
    ADD CONSTRAINT bulk_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 5883 (class 2606 OID 766985)
-- Name: bulk_uploads bulk_uploads_upload_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bulk_uploads
    ADD CONSTRAINT bulk_uploads_upload_id_unique UNIQUE (upload_id);


--
-- TOC entry 5886 (class 2606 OID 766987)
-- Name: coolers coolers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coolers
    ADD CONSTRAINT coolers_pkey PRIMARY KEY (id);


--
-- TOC entry 5888 (class 2606 OID 766989)
-- Name: counters counters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counters
    ADD CONSTRAINT counters_pkey PRIMARY KEY (id);


--
-- TOC entry 5890 (class 2606 OID 766991)
-- Name: daily_task_status daily_task_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_task_status
    ADD CONSTRAINT daily_task_status_pkey PRIMARY KEY (id);


--
-- TOC entry 5892 (class 2606 OID 766993)
-- Name: dashboards dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- TOC entry 5894 (class 2606 OID 766995)
-- Name: edit_requests edit_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_requests
    ADD CONSTRAINT edit_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5896 (class 2606 OID 766997)
-- Name: edit_requests edit_requests_request_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_requests
    ADD CONSTRAINT edit_requests_request_id_unique UNIQUE (request_id);


--
-- TOC entry 5898 (class 2606 OID 766999)
-- Name: email_status email_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_status
    ADD CONSTRAINT email_status_pkey PRIMARY KEY (id);


--
-- TOC entry 5900 (class 2606 OID 767001)
-- Name: error_image_inputs error_image_inputs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_image_inputs
    ADD CONSTRAINT error_image_inputs_pkey PRIMARY KEY (id);


--
-- TOC entry 5903 (class 2606 OID 767003)
-- Name: image_check_result image_check_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_check_result
    ADD CONSTRAINT image_check_result_pkey PRIMARY KEY (id);


--
-- TOC entry 5905 (class 2606 OID 767005)
-- Name: image_collections image_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_pkey PRIMARY KEY (id);


--
-- TOC entry 5907 (class 2606 OID 767007)
-- Name: image_container_brand_shares image_container_brand_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_brand_shares
    ADD CONSTRAINT image_container_brand_shares_pkey PRIMARY KEY (id);


--
-- TOC entry 5909 (class 2606 OID 767009)
-- Name: image_container_doors image_container_doors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_doors
    ADD CONSTRAINT image_container_doors_pkey PRIMARY KEY (id);


--
-- TOC entry 5911 (class 2606 OID 767011)
-- Name: image_container_product_shares image_container_product_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_product_shares
    ADD CONSTRAINT image_container_product_shares_pkey PRIMARY KEY (id);


--
-- TOC entry 5913 (class 2606 OID 767013)
-- Name: image_container_products image_container_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_products
    ADD CONSTRAINT image_container_products_pkey PRIMARY KEY (id);


--
-- TOC entry 5915 (class 2606 OID 767015)
-- Name: image_container_sections image_container_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_sections
    ADD CONSTRAINT image_container_sections_pkey PRIMARY KEY (id);


--
-- TOC entry 5917 (class 2606 OID 767017)
-- Name: image_container_stacks image_container_stacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_stacks
    ADD CONSTRAINT image_container_stacks_pkey PRIMARY KEY (id);


--
-- TOC entry 5919 (class 2606 OID 767019)
-- Name: image_containers image_containers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_containers
    ADD CONSTRAINT image_containers_pkey PRIMARY KEY (id);


--
-- TOC entry 5921 (class 2606 OID 767021)
-- Name: image_metadatas image_metadatas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_metadatas
    ADD CONSTRAINT image_metadatas_pkey PRIMARY KEY (id);


--
-- TOC entry 5923 (class 2606 OID 767024)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5925 (class 2606 OID 767026)
-- Name: models models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_pkey PRIMARY KEY (id);


--
-- TOC entry 5927 (class 2606 OID 767028)
-- Name: muse_planograms muse_planograms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muse_planograms
    ADD CONSTRAINT muse_planograms_pkey PRIMARY KEY (id);


--
-- TOC entry 5932 (class 2606 OID 767030)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 6051 (class 2606 OID 772195)
-- Name: org_nodes org_nodes_organisation_id_path_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_nodes
    ADD CONSTRAINT org_nodes_organisation_id_path_unique UNIQUE (organisation_id, path);


--
-- TOC entry 6053 (class 2606 OID 772193)
-- Name: org_nodes org_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_nodes
    ADD CONSTRAINT org_nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 6057 (class 2606 OID 772208)
-- Name: organisation_levels organisation_levels_organisation_id_code_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_levels
    ADD CONSTRAINT organisation_levels_organisation_id_code_unique UNIQUE (organisation_id, code);


--
-- TOC entry 6059 (class 2606 OID 772210)
-- Name: organisation_levels organisation_levels_organisation_id_level_order_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_levels
    ADD CONSTRAINT organisation_levels_organisation_id_level_order_unique UNIQUE (organisation_id, level_order);


--
-- TOC entry 6061 (class 2606 OID 772206)
-- Name: organisation_levels organisation_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_levels
    ADD CONSTRAINT organisation_levels_pkey PRIMARY KEY (id);


--
-- TOC entry 5934 (class 2606 OID 767032)
-- Name: organisations organisations_organisation_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_organisation_id_unique UNIQUE (organisation_id);


--
-- TOC entry 5936 (class 2606 OID 767034)
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- TOC entry 5938 (class 2606 OID 767036)
-- Name: planograms planograms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planograms
    ADD CONSTRAINT planograms_pkey PRIMARY KEY (id);


--
-- TOC entry 5940 (class 2606 OID 767038)
-- Name: poc_image poc_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc_image
    ADD CONSTRAINT poc_image_pkey PRIMARY KEY (id);


--
-- TOC entry 5942 (class 2606 OID 767040)
-- Name: poc_images poc_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc_images
    ADD CONSTRAINT poc_images_pkey PRIMARY KEY (id);


--
-- TOC entry 5947 (class 2606 OID 767042)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- TOC entry 5949 (class 2606 OID 767044)
-- Name: questions questions_question_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_question_id_unique UNIQUE (question_id);


--
-- TOC entry 5953 (class 2606 OID 767046)
-- Name: recognition_jobs recognition_jobs_job_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recognition_jobs
    ADD CONSTRAINT recognition_jobs_job_id_unique UNIQUE (job_id);


--
-- TOC entry 5955 (class 2606 OID 767048)
-- Name: recognition_jobs recognition_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recognition_jobs
    ADD CONSTRAINT recognition_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 5957 (class 2606 OID 767050)
-- Name: responses responses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_pkey PRIMARY KEY (id);


--
-- TOC entry 5959 (class 2606 OID 767052)
-- Name: responses responses_r_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_r_id_unique UNIQUE (r_id);


--
-- TOC entry 5961 (class 2606 OID 767054)
-- Name: roboflow_projects roboflow_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roboflow_projects
    ADD CONSTRAINT roboflow_projects_pkey PRIMARY KEY (id);


--
-- TOC entry 5964 (class 2606 OID 767056)
-- Name: role_accesses role_accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_accesses
    ADD CONSTRAINT role_accesses_pkey PRIMARY KEY (id);


--
-- TOC entry 5966 (class 2606 OID 767058)
-- Name: role_accesses role_accesses_role_id_access_to_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_accesses
    ADD CONSTRAINT role_accesses_role_id_access_to_unique UNIQUE (role_id, access_to);


--
-- TOC entry 5971 (class 2606 OID 767060)
-- Name: roles roles_organisation_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_organisation_id_name_unique UNIQUE (organisation_id, name);


--
-- TOC entry 5973 (class 2606 OID 767062)
-- Name: roles roles_organisation_id_role_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_organisation_id_role_id_unique UNIQUE (organisation_id, role_id);


--
-- TOC entry 5975 (class 2606 OID 767064)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5977 (class 2606 OID 767066)
-- Name: roles roles_role_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_id_unique UNIQUE (role_id);


--
-- TOC entry 5980 (class 2606 OID 767068)
-- Name: scheduled_visits scheduled_visits_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_visits
    ADD CONSTRAINT scheduled_visits_new_pkey PRIMARY KEY (id);


--
-- TOC entry 5985 (class 2606 OID 767070)
-- Name: shelf_ex_skus shelf_ex_skus_code_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelf_ex_skus
    ADD CONSTRAINT shelf_ex_skus_code_unique UNIQUE (code);


--
-- TOC entry 5987 (class 2606 OID 767072)
-- Name: shelf_ex_skus shelf_ex_skus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelf_ex_skus
    ADD CONSTRAINT shelf_ex_skus_pkey PRIMARY KEY (id);


--
-- TOC entry 5997 (class 2606 OID 767074)
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- TOC entry 5999 (class 2606 OID 767076)
-- Name: shops shops_shop_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_shop_id_unique UNIQUE (shop_id);


--
-- TOC entry 6001 (class 2606 OID 767078)
-- Name: skus skus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT skus_pkey PRIMARY KEY (id);


--
-- TOC entry 6004 (class 2606 OID 767080)
-- Name: skus skus_sku_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT skus_sku_id_unique UNIQUE (sku_id);


--
-- TOC entry 6006 (class 2606 OID 767082)
-- Name: special_accesses special_accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_accesses
    ADD CONSTRAINT special_accesses_pkey PRIMARY KEY (id);


--
-- TOC entry 6008 (class 2606 OID 767084)
-- Name: special_accesses special_accesses_user_id_access_to_access_type_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_accesses
    ADD CONSTRAINT special_accesses_user_id_access_to_access_type_unique UNIQUE (user_id, access_to, access_type);


--
-- TOC entry 6010 (class 2606 OID 767086)
-- Name: store_coolers store_coolers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_coolers
    ADD CONSTRAINT store_coolers_pkey PRIMARY KEY (id);


--
-- TOC entry 6012 (class 2606 OID 767088)
-- Name: store_planograms store_planograms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_planograms
    ADD CONSTRAINT store_planograms_pkey PRIMARY KEY (id);


--
-- TOC entry 6017 (class 2606 OID 767090)
-- Name: surveys surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- TOC entry 6019 (class 2606 OID 767092)
-- Name: surveys surveys_survey_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_survey_id_unique UNIQUE (survey_id);


--
-- TOC entry 6021 (class 2606 OID 767094)
-- Name: surveys surveys_title_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_title_unique UNIQUE (title);


--
-- TOC entry 6023 (class 2606 OID 767096)
-- Name: task_assignment_failures task_assignment_failures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignment_failures
    ADD CONSTRAINT task_assignment_failures_pkey PRIMARY KEY (id);


--
-- TOC entry 6025 (class 2606 OID 767098)
-- Name: thumbnails thumbnails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thumbnails
    ADD CONSTRAINT thumbnails_pkey PRIMARY KEY (id);


--
-- TOC entry 6030 (class 2606 OID 767100)
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- TOC entry 6035 (class 2606 OID 767102)
-- Name: user_activity user_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity
    ADD CONSTRAINT user_activity_pkey PRIMARY KEY (id);


--
-- TOC entry 6038 (class 2606 OID 767104)
-- Name: user_routes user_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_routes
    ADD CONSTRAINT user_routes_pkey PRIMARY KEY (id);


--
-- TOC entry 6042 (class 2606 OID 767106)
-- Name: visits visits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- TOC entry 6044 (class 2606 OID 767108)
-- Name: visits visits_visit_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_visit_id_unique UNIQUE (visit_id);


--
-- TOC entry 5857 (class 1259 OID 767109)
-- Name: admin_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_admin_id_idx ON public.admins USING btree (admin_id);


--
-- TOC entry 5858 (class 1259 OID 767110)
-- Name: admin_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_email_idx ON public.admins USING btree (email);


--
-- TOC entry 6039 (class 1259 OID 767111)
-- Name: admin_id_visits_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_id_visits_idx ON public.visits USING btree (admin_id);


--
-- TOC entry 5859 (class 1259 OID 767112)
-- Name: admin_manager_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_manager_id_idx ON public.admins USING btree (manager_id);


--
-- TOC entry 5860 (class 1259 OID 772259)
-- Name: admin_org_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_org_node_id_idx ON public.admins USING btree (org_node_id);


--
-- TOC entry 5861 (class 1259 OID 767113)
-- Name: admin_organisation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_organisation_id_idx ON public.admins USING btree (organisation_id);


--
-- TOC entry 5862 (class 1259 OID 767114)
-- Name: admin_user_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_user_name_idx ON public.admins USING btree (username);


--
-- TOC entry 5869 (class 1259 OID 767115)
-- Name: asrl_assigned_survey_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asrl_assigned_survey_idx ON public.assigned_survey_reason_logs USING btree (assigned_survey_id);


--
-- TOC entry 5872 (class 1259 OID 767116)
-- Name: assigned_survey_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assigned_survey_admin_id_idx ON public.assigned_surveys USING btree (admin_id);


--
-- TOC entry 5873 (class 1259 OID 767117)
-- Name: assigned_survey_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assigned_survey_service_id_idx ON public.assigned_surveys USING btree (service_id);


--
-- TOC entry 5874 (class 1259 OID 767120)
-- Name: assigned_survey_surveyor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assigned_survey_surveyor_id_idx ON public.assigned_surveys USING btree (surveyor_id);


--
-- TOC entry 5879 (class 1259 OID 767121)
-- Name: bulk_upload_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bulk_upload_admin_id_idx ON public.bulk_uploads USING btree (admin_id);


--
-- TOC entry 5901 (class 1259 OID 767122)
-- Name: image_check_result_organisation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX image_check_result_organisation_id_idx ON public.image_check_result USING btree (organisation_id);


--
-- TOC entry 5928 (class 1259 OID 767123)
-- Name: notification__admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notification__admin_id_idx ON public.notifications USING btree (admin_id);


--
-- TOC entry 5929 (class 1259 OID 767124)
-- Name: notification_notification_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notification_notification_id_idx ON public.notifications USING btree (notification_id);


--
-- TOC entry 5930 (class 1259 OID 767125)
-- Name: notification_read_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notification_read_idx ON public.notifications USING btree (read);


--
-- TOC entry 6054 (class 1259 OID 772248)
-- Name: org_level_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_level_org_id_idx ON public.organisation_levels USING btree (organisation_id);


--
-- TOC entry 6055 (class 1259 OID 774084)
-- Name: org_level_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_level_role_id_idx ON public.organisation_levels USING btree (role_id);


--
-- TOC entry 6045 (class 1259 OID 772243)
-- Name: org_node_level_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_node_level_id_idx ON public.org_nodes USING btree (level_id);


--
-- TOC entry 6046 (class 1259 OID 772247)
-- Name: org_node_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_node_org_id_idx ON public.org_nodes USING btree (organisation_id);


--
-- TOC entry 6047 (class 1259 OID 772242)
-- Name: org_node_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_node_parent_id_idx ON public.org_nodes USING btree (parent_id);


--
-- TOC entry 6048 (class 1259 OID 774085)
-- Name: org_node_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_node_path_idx ON public.org_nodes USING btree (path varchar_pattern_ops);


--
-- TOC entry 6049 (class 1259 OID 774083)
-- Name: org_node_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_node_role_id_idx ON public.org_nodes USING btree (role_id);


--
-- TOC entry 5943 (class 1259 OID 767126)
-- Name: question_question_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_question_id_idx ON public.questions USING btree (question_id);


--
-- TOC entry 5944 (class 1259 OID 767127)
-- Name: question_survey_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_survey_id_idx ON public.questions USING btree (survey_id);


--
-- TOC entry 5945 (class 1259 OID 767128)
-- Name: question_survey_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_survey_idx ON public.questions USING btree (question_id, survey_id);


--
-- TOC entry 5950 (class 1259 OID 767129)
-- Name: recognition_jobs_assigned_surevy_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recognition_jobs_assigned_surevy_id_idx ON public.recognition_jobs USING btree (assigned_surevy_id);


--
-- TOC entry 5951 (class 1259 OID 767130)
-- Name: recognition_jobs_job_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recognition_jobs_job_id_idx ON public.recognition_jobs USING btree (job_id);


--
-- TOC entry 5962 (class 1259 OID 767131)
-- Name: role_access_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX role_access_role_id_idx ON public.role_accesses USING btree (role_id);


--
-- TOC entry 5967 (class 1259 OID 767132)
-- Name: role_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX role_admin_id_idx ON public.roles USING btree (admin_id);


--
-- TOC entry 5968 (class 1259 OID 767133)
-- Name: role_organisation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX role_organisation_id_idx ON public.roles USING btree (organisation_id);


--
-- TOC entry 5969 (class 1259 OID 767134)
-- Name: role_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX role_role_id_idx ON public.roles USING btree (role_id);


--
-- TOC entry 5978 (class 1259 OID 768595)
-- Name: scheduled_visits_frequency_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduled_visits_frequency_idx ON public.scheduled_visits USING btree (frequency);


--
-- TOC entry 5981 (class 1259 OID 768593)
-- Name: scheduled_visits_route_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduled_visits_route_id_idx ON public.scheduled_visits USING btree (route_id);


--
-- TOC entry 5982 (class 1259 OID 768594)
-- Name: scheduled_visits_shop_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scheduled_visits_shop_id_idx ON public.scheduled_visits USING btree (shop_id);


--
-- TOC entry 5983 (class 1259 OID 767135)
-- Name: shelf_ex_skus_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shelf_ex_skus_code_idx ON public.shelf_ex_skus USING btree (code);


--
-- TOC entry 5988 (class 1259 OID 767136)
-- Name: shop_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_admin_id_idx ON public.shops USING btree (admin_id);


--
-- TOC entry 5989 (class 1259 OID 767137)
-- Name: shop_company_shop_id_organisation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_company_shop_id_organisation_id_idx ON public.shops USING btree (company_shop_id, organisation_id);


--
-- TOC entry 5990 (class 1259 OID 772260)
-- Name: shop_org_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_org_node_id_idx ON public.shops USING btree (org_node_id);


--
-- TOC entry 5991 (class 1259 OID 767138)
-- Name: shop_organisation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_organisation_id_idx ON public.shops USING btree (organisation_id);


--
-- TOC entry 5992 (class 1259 OID 767139)
-- Name: shop_shop_id_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_shop_id_admin_id_idx ON public.shops USING btree (shop_id, admin_id);


--
-- TOC entry 5993 (class 1259 OID 767140)
-- Name: shop_shop_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_shop_id_idx ON public.shops USING btree (shop_id);


--
-- TOC entry 5994 (class 1259 OID 767141)
-- Name: shop_shop_id_organisation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_shop_id_organisation_id_idx ON public.shops USING btree (shop_id, organisation_id);


--
-- TOC entry 5995 (class 1259 OID 767142)
-- Name: shop_unit_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shop_unit_id_idx ON public.shops USING btree (unit_id);


--
-- TOC entry 6002 (class 1259 OID 767143)
-- Name: skus_product_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX skus_product_code_idx ON public.skus USING btree (product_code);


--
-- TOC entry 6013 (class 1259 OID 767144)
-- Name: survey_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX survey_admin_id_idx ON public.surveys USING btree (admin_id);


--
-- TOC entry 6014 (class 1259 OID 767145)
-- Name: survey_admin_id_survey_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX survey_admin_id_survey_id_idx ON public.surveys USING btree (admin_id, survey_id);


--
-- TOC entry 6015 (class 1259 OID 767146)
-- Name: survey_survey_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX survey_survey_id_idx ON public.surveys USING btree (survey_id);


--
-- TOC entry 6026 (class 1259 OID 767147)
-- Name: unit_organisation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unit_organisation_id_idx ON public.units USING btree (organisation_id);


--
-- TOC entry 6027 (class 1259 OID 767148)
-- Name: unit_unit_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unit_unit_code_idx ON public.units USING btree (unit_code);


--
-- TOC entry 6028 (class 1259 OID 767149)
-- Name: unit_unit_head_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unit_unit_head_id_idx ON public.units USING btree (unit_head_id);


--
-- TOC entry 5884 (class 1259 OID 767150)
-- Name: upload_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX upload_id_idx ON public.bulk_uploads USING btree (upload_id);


--
-- TOC entry 6031 (class 1259 OID 767151)
-- Name: user_activity_admin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_activity_admin_id_idx ON public.user_activity USING btree (admin_id);


--
-- TOC entry 6032 (class 1259 OID 767152)
-- Name: user_activity_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_activity_created_at_idx ON public.user_activity USING btree (created_at);


--
-- TOC entry 6033 (class 1259 OID 767153)
-- Name: user_activity_page_url_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_activity_page_url_idx ON public.user_activity USING btree (page_url);


--
-- TOC entry 6036 (class 1259 OID 767157)
-- Name: user_activity_portal_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_activity_portal_type_idx ON public.user_activity USING btree (portal_type);


--
-- TOC entry 6040 (class 1259 OID 767159)
-- Name: visit_id_visits_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX visit_id_visits_idx ON public.visits USING btree (visit_id);


--
-- TOC entry 6171 (class 2620 OID 767161)
-- Name: shops trg_update_shop_key; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_shop_key BEFORE UPDATE OF organisation_id, route_id, store_name, geographic_location, company_shop_id, status ON public.shops FOR EACH ROW EXECUTE FUNCTION public.update_shop_key();


--
-- TOC entry 6062 (class 2606 OID 767162)
-- Name: add_emp_roles add_emp_roles_role_access_id_role_accesses_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_emp_roles
    ADD CONSTRAINT add_emp_roles_role_access_id_role_accesses_id_fk FOREIGN KEY (role_access_id) REFERENCES public.role_accesses(id) ON DELETE CASCADE;


--
-- TOC entry 6063 (class 2606 OID 767167)
-- Name: add_emp_roles add_emp_roles_role_id_roles_role_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_emp_roles
    ADD CONSTRAINT add_emp_roles_role_id_roles_role_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- TOC entry 6064 (class 2606 OID 767172)
-- Name: add_emp_roles add_emp_roles_special_access_id_special_accesses_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.add_emp_roles
    ADD CONSTRAINT add_emp_roles_special_access_id_special_accesses_id_fk FOREIGN KEY (special_access_id) REFERENCES public.special_accesses(id) ON DELETE CASCADE;


--
-- TOC entry 6065 (class 2606 OID 767177)
-- Name: admins admins_manager_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_manager_id_admins_id_fk FOREIGN KEY (manager_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6066 (class 2606 OID 772249)
-- Name: admins admins_org_node_id_org_nodes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_org_node_id_org_nodes_id_fk FOREIGN KEY (org_node_id) REFERENCES public.org_nodes(id) ON DELETE SET NULL;


--
-- TOC entry 6067 (class 2606 OID 767182)
-- Name: admins admins_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id) ON DELETE CASCADE;


--
-- TOC entry 6068 (class 2606 OID 767187)
-- Name: admins admins_role_id_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 6069 (class 2606 OID 767192)
-- Name: assigned_survey_reason_logs assigned_survey_reason_logs_assigned_survey_id_assigned_surveys; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_survey_reason_logs
    ADD CONSTRAINT assigned_survey_reason_logs_assigned_survey_id_assigned_surveys FOREIGN KEY (assigned_survey_id) REFERENCES public.assigned_surveys(id) ON DELETE CASCADE;


--
-- TOC entry 6070 (class 2606 OID 767197)
-- Name: assigned_surveys assigned_surveys_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6071 (class 2606 OID 767202)
-- Name: assigned_surveys assigned_surveys_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6072 (class 2606 OID 767207)
-- Name: assigned_surveys assigned_surveys_shop_id_shops_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_shop_id_shops_id_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 6073 (class 2606 OID 767212)
-- Name: assigned_surveys assigned_surveys_survey_id_surveys_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_survey_id_surveys_id_fk FOREIGN KEY (survey_id) REFERENCES public.surveys(id) ON DELETE CASCADE;


--
-- TOC entry 6074 (class 2606 OID 767217)
-- Name: assigned_surveys assigned_surveys_surveyor_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_surveyor_id_admins_id_fk FOREIGN KEY (surveyor_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6075 (class 2606 OID 767223)
-- Name: assigned_surveys assigned_surveys_visit_id_visits_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_surveys
    ADD CONSTRAINT assigned_surveys_visit_id_visits_id_fk FOREIGN KEY (visit_id) REFERENCES public.visits(id) ON DELETE CASCADE;


--
-- TOC entry 6076 (class 2606 OID 767228)
-- Name: bulk_uploads bulk_uploads_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bulk_uploads
    ADD CONSTRAINT bulk_uploads_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6077 (class 2606 OID 767233)
-- Name: bulk_uploads bulk_uploads_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bulk_uploads
    ADD CONSTRAINT bulk_uploads_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6078 (class 2606 OID 767238)
-- Name: coolers coolers_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coolers
    ADD CONSTRAINT coolers_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- TOC entry 6079 (class 2606 OID 767243)
-- Name: coolers coolers_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coolers
    ADD CONSTRAINT coolers_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6080 (class 2606 OID 767248)
-- Name: dashboards dashboards_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6081 (class 2606 OID 767253)
-- Name: edit_requests edit_requests_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_requests
    ADD CONSTRAINT edit_requests_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6082 (class 2606 OID 767258)
-- Name: edit_requests edit_requests_surveyor_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_requests
    ADD CONSTRAINT edit_requests_surveyor_id_admins_id_fk FOREIGN KEY (surveyor_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6083 (class 2606 OID 767263)
-- Name: error_image_inputs error_image_inputs_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_image_inputs
    ADD CONSTRAINT error_image_inputs_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6084 (class 2606 OID 767268)
-- Name: error_image_inputs error_image_inputs_bulk_upload_id_bulk_uploads_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_image_inputs
    ADD CONSTRAINT error_image_inputs_bulk_upload_id_bulk_uploads_id_fk FOREIGN KEY (bulk_upload_id) REFERENCES public.bulk_uploads(id);


--
-- TOC entry 6085 (class 2606 OID 767273)
-- Name: error_image_inputs error_image_inputs_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_image_inputs
    ADD CONSTRAINT error_image_inputs_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6086 (class 2606 OID 767278)
-- Name: error_image_inputs error_image_inputs_shop_id_shops_shop_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_image_inputs
    ADD CONSTRAINT error_image_inputs_shop_id_shops_shop_id_fk FOREIGN KEY (shop_id) REFERENCES public.shops(shop_id) ON DELETE CASCADE;


--
-- TOC entry 6087 (class 2606 OID 767283)
-- Name: error_image_inputs error_image_inputs_sku_id_skus_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_image_inputs
    ADD CONSTRAINT error_image_inputs_sku_id_skus_sku_id_fk FOREIGN KEY (sku_id) REFERENCES public.skus(sku_id) ON DELETE CASCADE;


--
-- TOC entry 6088 (class 2606 OID 767288)
-- Name: image_check_result image_check_result_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_check_result
    ADD CONSTRAINT image_check_result_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6089 (class 2606 OID 767293)
-- Name: image_check_result image_check_result_assigned_survey_id_assigned_surveys_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_check_result
    ADD CONSTRAINT image_check_result_assigned_survey_id_assigned_surveys_id_fk FOREIGN KEY (assigned_survey_id) REFERENCES public.assigned_surveys(id) ON DELETE CASCADE;


--
-- TOC entry 6090 (class 2606 OID 767298)
-- Name: image_check_result image_check_result_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_check_result
    ADD CONSTRAINT image_check_result_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6091 (class 2606 OID 767303)
-- Name: image_collections image_collections_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6092 (class 2606 OID 767308)
-- Name: image_collections image_collections_cooler_id_coolers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_cooler_id_coolers_id_fk FOREIGN KEY (cooler_id) REFERENCES public.coolers(id) ON DELETE CASCADE;


--
-- TOC entry 6093 (class 2606 OID 767313)
-- Name: image_collections image_collections_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id) ON DELETE CASCADE;


--
-- TOC entry 6094 (class 2606 OID 767318)
-- Name: image_collections image_collections_planogram_id_planograms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_planogram_id_planograms_id_fk FOREIGN KEY (planogram_id) REFERENCES public.planograms(id) ON DELETE CASCADE;


--
-- TOC entry 6095 (class 2606 OID 767323)
-- Name: image_collections image_collections_service_id_assigned_surveys_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_service_id_assigned_surveys_id_fk FOREIGN KEY (service_id) REFERENCES public.assigned_surveys(id) ON DELETE CASCADE;


--
-- TOC entry 6096 (class 2606 OID 767328)
-- Name: image_collections image_collections_shop_id_shops_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_shop_id_shops_id_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 6097 (class 2606 OID 767333)
-- Name: image_collections image_collections_surveyor_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_collections
    ADD CONSTRAINT image_collections_surveyor_id_admins_id_fk FOREIGN KEY (surveyor_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6098 (class 2606 OID 767338)
-- Name: image_container_brand_shares image_container_brand_shares_image_collection_id_image_collecti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_brand_shares
    ADD CONSTRAINT image_container_brand_shares_image_collection_id_image_collecti FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6099 (class 2606 OID 767343)
-- Name: image_container_doors image_container_doors_image_collection_id_image_collections_id_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_doors
    ADD CONSTRAINT image_container_doors_image_collection_id_image_collections_id_ FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6100 (class 2606 OID 767348)
-- Name: image_container_doors image_container_doors_image_container_id_image_containers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_doors
    ADD CONSTRAINT image_container_doors_image_container_id_image_containers_id_fk FOREIGN KEY (image_container_id) REFERENCES public.image_containers(id) ON DELETE CASCADE;


--
-- TOC entry 6101 (class 2606 OID 767353)
-- Name: image_container_product_shares image_container_product_shares_brand_share_id_image_container_b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_product_shares
    ADD CONSTRAINT image_container_product_shares_brand_share_id_image_container_b FOREIGN KEY (brand_share_id) REFERENCES public.image_container_brand_shares(id) ON DELETE CASCADE;


--
-- TOC entry 6102 (class 2606 OID 767358)
-- Name: image_container_product_shares image_container_product_shares_image_collection_id_image_collec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_product_shares
    ADD CONSTRAINT image_container_product_shares_image_collection_id_image_collec FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6103 (class 2606 OID 767363)
-- Name: image_container_products image_container_products_image_collection_id_image_collections_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_products
    ADD CONSTRAINT image_container_products_image_collection_id_image_collections_ FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6104 (class 2606 OID 767368)
-- Name: image_container_products image_container_products_image_container_section_id_image_conta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_products
    ADD CONSTRAINT image_container_products_image_container_section_id_image_conta FOREIGN KEY (image_container_section_id) REFERENCES public.image_container_sections(id) ON DELETE CASCADE;


--
-- TOC entry 6105 (class 2606 OID 767373)
-- Name: image_container_sections image_container_sections_image_collection_id_image_collections_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_sections
    ADD CONSTRAINT image_container_sections_image_collection_id_image_collections_ FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6106 (class 2606 OID 767378)
-- Name: image_container_sections image_container_sections_image_container_door_id_image_containe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_sections
    ADD CONSTRAINT image_container_sections_image_container_door_id_image_containe FOREIGN KEY (image_container_door_id) REFERENCES public.image_container_doors(id) ON DELETE CASCADE;


--
-- TOC entry 6107 (class 2606 OID 767383)
-- Name: image_container_stacks image_container_stacks_image_collection_id_image_collections_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_stacks
    ADD CONSTRAINT image_container_stacks_image_collection_id_image_collections_id FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6108 (class 2606 OID 767388)
-- Name: image_container_stacks image_container_stacks_image_container_product_id_image_contain; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_container_stacks
    ADD CONSTRAINT image_container_stacks_image_container_product_id_image_contain FOREIGN KEY (image_container_product_id) REFERENCES public.image_container_products(id) ON DELETE CASCADE;


--
-- TOC entry 6109 (class 2606 OID 767393)
-- Name: image_containers image_containers_image_collection_id_image_collections_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_containers
    ADD CONSTRAINT image_containers_image_collection_id_image_collections_id_fk FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6110 (class 2606 OID 767398)
-- Name: image_containers image_containers_image_metadata_id_image_metadatas_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_containers
    ADD CONSTRAINT image_containers_image_metadata_id_image_metadatas_id_fk FOREIGN KEY (image_metadata_id) REFERENCES public.image_metadatas(id) ON DELETE CASCADE;


--
-- TOC entry 6111 (class 2606 OID 767403)
-- Name: image_metadatas image_metadatas_image_collection_id_image_collections_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image_metadatas
    ADD CONSTRAINT image_metadatas_image_collection_id_image_collections_id_fk FOREIGN KEY (image_collection_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6112 (class 2606 OID 767408)
-- Name: models models_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6113 (class 2606 OID 767413)
-- Name: muse_planograms muse_planograms_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muse_planograms
    ADD CONSTRAINT muse_planograms_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- TOC entry 6114 (class 2606 OID 767418)
-- Name: muse_planograms muse_planograms_cooler_id_coolers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muse_planograms
    ADD CONSTRAINT muse_planograms_cooler_id_coolers_id_fk FOREIGN KEY (cooler_id) REFERENCES public.coolers(id);


--
-- TOC entry 6115 (class 2606 OID 767423)
-- Name: muse_planograms muse_planograms_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muse_planograms
    ADD CONSTRAINT muse_planograms_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6116 (class 2606 OID 767428)
-- Name: notifications notifications_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6165 (class 2606 OID 772221)
-- Name: org_nodes org_nodes_level_id_organisation_levels_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_nodes
    ADD CONSTRAINT org_nodes_level_id_organisation_levels_id_fk FOREIGN KEY (level_id) REFERENCES public.organisation_levels(id) ON DELETE RESTRICT;


--
-- TOC entry 6166 (class 2606 OID 772211)
-- Name: org_nodes org_nodes_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_nodes
    ADD CONSTRAINT org_nodes_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id) ON DELETE CASCADE;


--
-- TOC entry 6167 (class 2606 OID 772216)
-- Name: org_nodes org_nodes_parent_id_org_nodes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_nodes
    ADD CONSTRAINT org_nodes_parent_id_org_nodes_id_fk FOREIGN KEY (parent_id) REFERENCES public.org_nodes(id) ON DELETE CASCADE;


--
-- TOC entry 6168 (class 2606 OID 772226)
-- Name: org_nodes org_nodes_role_id_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_nodes
    ADD CONSTRAINT org_nodes_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE SET NULL;


--
-- TOC entry 6169 (class 2606 OID 772231)
-- Name: organisation_levels organisation_levels_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_levels
    ADD CONSTRAINT organisation_levels_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id) ON DELETE CASCADE;


--
-- TOC entry 6170 (class 2606 OID 772236)
-- Name: organisation_levels organisation_levels_role_id_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_levels
    ADD CONSTRAINT organisation_levels_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE SET NULL;


--
-- TOC entry 6117 (class 2606 OID 767433)
-- Name: planograms planograms_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planograms
    ADD CONSTRAINT planograms_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- TOC entry 6118 (class 2606 OID 767438)
-- Name: planograms planograms_cooler_id_coolers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planograms
    ADD CONSTRAINT planograms_cooler_id_coolers_id_fk FOREIGN KEY (cooler_id) REFERENCES public.coolers(id);


--
-- TOC entry 6119 (class 2606 OID 767443)
-- Name: planograms planograms_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planograms
    ADD CONSTRAINT planograms_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6120 (class 2606 OID 767448)
-- Name: poc_image poc_image_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc_image
    ADD CONSTRAINT poc_image_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6121 (class 2606 OID 767453)
-- Name: poc_images poc_images_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc_images
    ADD CONSTRAINT poc_images_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6122 (class 2606 OID 767458)
-- Name: poc_images poc_images_image_id_image_collections_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc_images
    ADD CONSTRAINT poc_images_image_id_image_collections_id_fk FOREIGN KEY (image_id) REFERENCES public.image_collections(id) ON DELETE CASCADE;


--
-- TOC entry 6123 (class 2606 OID 767463)
-- Name: questions questions_survey_id_surveys_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_survey_id_surveys_id_fk FOREIGN KEY (survey_id) REFERENCES public.surveys(id) ON DELETE CASCADE;


--
-- TOC entry 6124 (class 2606 OID 767468)
-- Name: recognition_jobs recognition_jobs_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recognition_jobs
    ADD CONSTRAINT recognition_jobs_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6125 (class 2606 OID 767473)
-- Name: recognition_jobs recognition_jobs_assigned_surevy_id_assigned_surveys_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recognition_jobs
    ADD CONSTRAINT recognition_jobs_assigned_surevy_id_assigned_surveys_id_fk FOREIGN KEY (assigned_surevy_id) REFERENCES public.assigned_surveys(id);


--
-- TOC entry 6126 (class 2606 OID 767478)
-- Name: recognition_jobs recognition_jobs_cooler_id_coolers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recognition_jobs
    ADD CONSTRAINT recognition_jobs_cooler_id_coolers_id_fk FOREIGN KEY (cooler_id) REFERENCES public.coolers(id);


--
-- TOC entry 6127 (class 2606 OID 767483)
-- Name: recognition_jobs recognition_jobs_planogram_id_planograms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recognition_jobs
    ADD CONSTRAINT recognition_jobs_planogram_id_planograms_id_fk FOREIGN KEY (planogram_id) REFERENCES public.planograms(id);


--
-- TOC entry 6128 (class 2606 OID 767488)
-- Name: responses responses_assigned_survey_id_assigned_surveys_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_assigned_survey_id_assigned_surveys_id_fk FOREIGN KEY (assigned_survey_id) REFERENCES public.assigned_surveys(id) ON DELETE CASCADE;


--
-- TOC entry 6129 (class 2606 OID 767493)
-- Name: responses responses_question_id_questions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_question_id_questions_id_fk FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- TOC entry 6130 (class 2606 OID 767498)
-- Name: role_accesses role_accesses_role_id_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_accesses
    ADD CONSTRAINT role_accesses_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 6131 (class 2606 OID 767503)
-- Name: roles roles_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6132 (class 2606 OID 767508)
-- Name: roles roles_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6133 (class 2606 OID 767513)
-- Name: scheduled_visits scheduled_visits_new_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_visits
    ADD CONSTRAINT scheduled_visits_new_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6134 (class 2606 OID 767518)
-- Name: scheduled_visits scheduled_visits_new_shop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_visits
    ADD CONSTRAINT scheduled_visits_new_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 6135 (class 2606 OID 768588)
-- Name: scheduled_visits scheduled_visits_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_visits
    ADD CONSTRAINT scheduled_visits_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6136 (class 2606 OID 768583)
-- Name: scheduled_visits scheduled_visits_shop_id_shops_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_visits
    ADD CONSTRAINT scheduled_visits_shop_id_shops_id_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 6137 (class 2606 OID 767523)
-- Name: shops shops_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6138 (class 2606 OID 772254)
-- Name: shops shops_org_node_id_org_nodes_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_org_node_id_org_nodes_id_fk FOREIGN KEY (org_node_id) REFERENCES public.org_nodes(id) ON DELETE SET NULL;


--
-- TOC entry 6139 (class 2606 OID 767528)
-- Name: shops shops_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6140 (class 2606 OID 767533)
-- Name: shops shops_unit_id_units_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_unit_id_units_id_fk FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 6141 (class 2606 OID 767538)
-- Name: skus skus_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT skus_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6142 (class 2606 OID 767543)
-- Name: skus skus_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT skus_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6143 (class 2606 OID 767548)
-- Name: skus skus_shelf_ex_sku_id_shelf_ex_skus_code_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT skus_shelf_ex_sku_id_shelf_ex_skus_code_fk FOREIGN KEY (shelf_ex_sku_id) REFERENCES public.shelf_ex_skus(code);


--
-- TOC entry 6144 (class 2606 OID 767553)
-- Name: special_accesses special_accesses_user_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_accesses
    ADD CONSTRAINT special_accesses_user_id_admins_id_fk FOREIGN KEY (user_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6145 (class 2606 OID 767558)
-- Name: store_coolers store_coolers_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_coolers
    ADD CONSTRAINT store_coolers_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- TOC entry 6146 (class 2606 OID 767563)
-- Name: store_coolers store_coolers_cooler_id_coolers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_coolers
    ADD CONSTRAINT store_coolers_cooler_id_coolers_id_fk FOREIGN KEY (cooler_id) REFERENCES public.coolers(id) ON DELETE CASCADE;


--
-- TOC entry 6147 (class 2606 OID 767568)
-- Name: store_coolers store_coolers_shop_id_shops_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_coolers
    ADD CONSTRAINT store_coolers_shop_id_shops_id_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 6148 (class 2606 OID 767573)
-- Name: store_planograms store_planograms_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_planograms
    ADD CONSTRAINT store_planograms_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- TOC entry 6149 (class 2606 OID 767578)
-- Name: store_planograms store_planograms_planogram_id_planograms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_planograms
    ADD CONSTRAINT store_planograms_planogram_id_planograms_id_fk FOREIGN KEY (planogram_id) REFERENCES public.planograms(id) ON DELETE CASCADE;


--
-- TOC entry 6150 (class 2606 OID 767583)
-- Name: store_planograms store_planograms_shop_id_shops_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_planograms
    ADD CONSTRAINT store_planograms_shop_id_shops_id_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 6151 (class 2606 OID 767588)
-- Name: surveys surveys_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6152 (class 2606 OID 767593)
-- Name: surveys surveys_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6153 (class 2606 OID 767598)
-- Name: task_assignment_failures task_assignment_failures_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignment_failures
    ADD CONSTRAINT task_assignment_failures_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- TOC entry 6154 (class 2606 OID 767603)
-- Name: thumbnails thumbnails_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thumbnails
    ADD CONSTRAINT thumbnails_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6155 (class 2606 OID 767608)
-- Name: thumbnails thumbnails_sku_id_skus_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thumbnails
    ADD CONSTRAINT thumbnails_sku_id_skus_sku_id_fk FOREIGN KEY (sku_id) REFERENCES public.skus(sku_id) ON DELETE CASCADE;


--
-- TOC entry 6156 (class 2606 OID 767613)
-- Name: units units_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6157 (class 2606 OID 767618)
-- Name: units units_unit_head_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_unit_head_id_admins_id_fk FOREIGN KEY (unit_head_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6158 (class 2606 OID 767623)
-- Name: user_activity user_activity_admin_id_admins_admin_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity
    ADD CONSTRAINT user_activity_admin_id_admins_admin_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(admin_id) ON DELETE CASCADE;


--
-- TOC entry 6159 (class 2606 OID 767628)
-- Name: user_routes user_routes_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_routes
    ADD CONSTRAINT user_routes_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6160 (class 2606 OID 767633)
-- Name: user_routes user_routes_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_routes
    ADD CONSTRAINT user_routes_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id) ON DELETE CASCADE;


--
-- TOC entry 6161 (class 2606 OID 767638)
-- Name: visits visits_admin_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_admin_id_admins_id_fk FOREIGN KEY (admin_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6162 (class 2606 OID 767643)
-- Name: visits visits_organisation_id_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_organisation_id_organisations_id_fk FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- TOC entry 6163 (class 2606 OID 767648)
-- Name: visits visits_survey_id_surveys_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_survey_id_surveys_id_fk FOREIGN KEY (survey_id) REFERENCES public.surveys(id) ON DELETE CASCADE;


--
-- TOC entry 6164 (class 2606 OID 767653)
-- Name: visits visits_surveyor_id_admins_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_surveyor_id_admins_id_fk FOREIGN KEY (surveyor_id) REFERENCES public.admins(id) ON DELETE CASCADE;


--
-- TOC entry 6329 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA google_vacuum_mgmt; Type: ACL; Schema: -; Owner: cloudsqladmin
--

GRANT USAGE ON SCHEMA google_vacuum_mgmt TO cloudsqlsuperuser;


--
-- TOC entry 6330 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO cloudsqlsuperuser;
GRANT USAGE ON SCHEMA public TO readonly_user;


--
-- TOC entry 6335 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE add_emp_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.add_emp_roles TO readonly_user;


--
-- TOC entry 6337 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE admins; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.admins TO readonly_user;


--
-- TOC entry 6339 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE assigned_survey_reason_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.assigned_survey_reason_logs TO readonly_user;


--
-- TOC entry 6341 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE assigned_surveys; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.assigned_surveys TO readonly_user;


--
-- TOC entry 6343 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE bulk_uploads; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.bulk_uploads TO readonly_user;


--
-- TOC entry 6345 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE coolers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.coolers TO readonly_user;


--
-- TOC entry 6347 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE counters; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.counters TO readonly_user;


--
-- TOC entry 6349 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE daily_task_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.daily_task_status TO readonly_user;


--
-- TOC entry 6351 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE dashboards; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.dashboards TO readonly_user;


--
-- TOC entry 6353 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE edit_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.edit_requests TO readonly_user;


--
-- TOC entry 6355 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE email_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.email_status TO readonly_user;


--
-- TOC entry 6357 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE error_image_inputs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.error_image_inputs TO readonly_user;


--
-- TOC entry 6359 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE geography_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.geography_columns TO readonly_user;


--
-- TOC entry 6360 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE geometry_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.geometry_columns TO readonly_user;


--
-- TOC entry 6361 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE image_check_result; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_check_result TO readonly_user;


--
-- TOC entry 6363 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE image_collections; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_collections TO readonly_user;


--
-- TOC entry 6365 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE image_container_brand_shares; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_container_brand_shares TO readonly_user;


--
-- TOC entry 6367 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE image_container_doors; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_container_doors TO readonly_user;


--
-- TOC entry 6369 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE image_container_product_shares; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_container_product_shares TO readonly_user;


--
-- TOC entry 6371 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE image_container_products; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_container_products TO readonly_user;


--
-- TOC entry 6373 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE image_container_sections; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_container_sections TO readonly_user;


--
-- TOC entry 6375 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE image_container_stacks; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_container_stacks TO readonly_user;


--
-- TOC entry 6377 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE image_containers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_containers TO readonly_user;


--
-- TOC entry 6379 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE image_metadatas; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image_metadatas TO readonly_user;


--
-- TOC entry 6381 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.logs TO readonly_user;


--
-- TOC entry 6383 (class 0 OID 0)
-- Dependencies: 285
-- Name: TABLE models; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.models TO readonly_user;


--
-- TOC entry 6385 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE muse_planograms; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.muse_planograms TO readonly_user;


--
-- TOC entry 6387 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.notifications TO readonly_user;


--
-- TOC entry 6389 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE org_nodes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.org_nodes TO readonly_user;


--
-- TOC entry 6391 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE organisation_levels; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.organisation_levels TO readonly_user;


--
-- TOC entry 6393 (class 0 OID 0)
-- Dependencies: 291
-- Name: TABLE organisations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.organisations TO readonly_user;


--
-- TOC entry 6395 (class 0 OID 0)
-- Dependencies: 293
-- Name: TABLE planograms; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.planograms TO readonly_user;


--
-- TOC entry 6397 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE poc_image; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.poc_image TO readonly_user;


--
-- TOC entry 6399 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE poc_images; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.poc_images TO readonly_user;


--
-- TOC entry 6401 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.questions TO readonly_user;


--
-- TOC entry 6403 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE raster_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.raster_columns TO readonly_user;


--
-- TOC entry 6404 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE raster_overviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.raster_overviews TO readonly_user;


--
-- TOC entry 6405 (class 0 OID 0)
-- Dependencies: 301
-- Name: TABLE recognition_jobs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.recognition_jobs TO readonly_user;


--
-- TOC entry 6407 (class 0 OID 0)
-- Dependencies: 303
-- Name: TABLE responses; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.responses TO readonly_user;


--
-- TOC entry 6409 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE roboflow_projects; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.roboflow_projects TO readonly_user;


--
-- TOC entry 6411 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE role_accesses; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.role_accesses TO readonly_user;


--
-- TOC entry 6413 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.roles TO readonly_user;


--
-- TOC entry 6415 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE scheduled_visits; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.scheduled_visits TO readonly_user;


--
-- TOC entry 6417 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE shelf_ex_skus; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.shelf_ex_skus TO readonly_user;


--
-- TOC entry 6419 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE shops; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.shops TO readonly_user;


--
-- TOC entry 6421 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE skus; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.skus TO readonly_user;


--
-- TOC entry 6423 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE spatial_ref_sys; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.spatial_ref_sys TO readonly_user;


--
-- TOC entry 6424 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE special_accesses; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.special_accesses TO readonly_user;


--
-- TOC entry 6426 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE store_coolers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.store_coolers TO readonly_user;


--
-- TOC entry 6428 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE store_planograms; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.store_planograms TO readonly_user;


--
-- TOC entry 6430 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE surveys; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.surveys TO readonly_user;


--
-- TOC entry 6432 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE task_assignment_failures; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.task_assignment_failures TO readonly_user;


--
-- TOC entry 6434 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE thumbnails; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.thumbnails TO readonly_user;


--
-- TOC entry 6436 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE units; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.units TO readonly_user;


--
-- TOC entry 6438 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE user_activity; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.user_activity TO readonly_user;


--
-- TOC entry 6440 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE user_routes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.user_routes TO readonly_user;


--
-- TOC entry 6442 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE visits; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.visits TO readonly_user;


--
-- TOC entry 3818 (class 826 OID 767658)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES TO readonly_user;


-- Completed on 2026-02-13 00:53:03

--
-- PostgreSQL database dump complete
--

