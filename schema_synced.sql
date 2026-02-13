-- Schema synced from live database: shelfscan-prod-v1
-- Synced at: 2026-02-13T13:19:48.326Z
-- Tables: 51

CREATE TABLE add_emp_roles (
  id integer NOT NULL DEFAULT nextval('add_emp_roles_id_seq'::regclass),
  role_access_id integer,
  special_access_id integer,
  role_id character varying,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admins (
  id integer NOT NULL DEFAULT nextval('admins_id_seq'::regclass),
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
  gender USER-DEFINED DEFAULT 'prefer_not_to_say'::gender_types,
  profile_img character varying(2500),
  email character varying(2500),
  status USER-DEFINED DEFAULT 'active'::user_status_types,
  is_super_admin boolean DEFAULT false,
  is_organisation_head boolean DEFAULT false,
  user_type USER-DEFINED DEFAULT 'employee'::user_types,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  web_tour_guide_watch boolean DEFAULT false,
  mobile_tour_guide_watch boolean DEFAULT false
);

CREATE TABLE assigned_survey_reason_logs (
  id integer NOT NULL DEFAULT nextval('assigned_survey_reason_logs_id_seq'::regclass),
  assigned_survey_id integer NOT NULL,
  reason character varying(2500) NOT NULL,
  images jsonb DEFAULT 'null'::jsonb,
  location jsonb,
  created_at timestamp without time zone DEFAULT now(),
  status USER-DEFINED DEFAULT 'NO_LOCATION_PROVIDED'::assigned_survey_reason_logs_status_types
);

CREATE TABLE assigned_surveys (
  id integer NOT NULL DEFAULT nextval('assigned_surveys_id_seq'::regclass),
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
  is_survey_mandatory boolean NOT NULL DEFAULT false,
  recognition_assigned boolean NOT NULL,
  recognition_completed boolean DEFAULT false,
  recognition_start_time timestamp without time zone,
  recognition_end_time timestamp without time zone,
  recognized_cooler_data jsonb,
  recognized_shelf_data jsonb,
  collection_assigned boolean NOT NULL DEFAULT false,
  collection_completed boolean DEFAULT false,
  status USER-DEFINED DEFAULT 'pending'::assigned_survey_status_types,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bulk_uploads (
  id integer NOT NULL DEFAULT nextval('bulk_uploads_id_seq'::regclass),
  upload_id character varying NOT NULL,
  admin_id integer,
  organisation_id integer NOT NULL,
  file_path text,
  total_rows integer,
  processed_rows integer DEFAULT 0,
  chunk_size integer DEFAULT 100,
  new_input_count integer DEFAULT 0,
  duplicate_input_count integer DEFAULT 0,
  status USER-DEFINED DEFAULT 'queued'::bulk_upload_status,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE coolers (
  id integer NOT NULL DEFAULT nextval('coolers_id_seq'::regclass),
  admin_id integer,
  organisation_id integer NOT NULL,
  name character varying(2500),
  type character varying(2500),
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  status USER-DEFINED DEFAULT 'active'::cooler_status
);

CREATE TABLE counters (
  id integer NOT NULL DEFAULT nextval('counters_id_seq'::regclass),
  name character varying(2500),
  last_id integer DEFAULT 0
);

CREATE TABLE daily_task_status (
  id integer NOT NULL DEFAULT nextval('daily_task_status_id_seq'::regclass),
  date character varying(2500),
  status character varying(2500),
  error text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tasks_assigned integer DEFAULT 0,
  visits_assigned integer DEFAULT 0
);

CREATE TABLE dashboards (
  id integer NOT NULL DEFAULT nextval('dashboards_id_seq'::regclass),
  organisation_id integer NOT NULL,
  name character varying(2500),
  url text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE edit_requests (
  id integer NOT NULL DEFAULT nextval('edit_requests_id_seq'::regclass),
  request_id character varying(2500),
  admin_id integer,
  surveyor_id integer,
  body jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE email_status (
  id integer NOT NULL DEFAULT nextval('email_status_id_seq'::regclass),
  email jsonb NOT NULL,
  status character varying(2500) NOT NULL,
  info jsonb,
  error jsonb,
  recipient jsonb,
  attachments jsonb,
  subject text,
  template_name text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE error_image_inputs (
  id integer NOT NULL DEFAULT nextval('error_image_inputs_id_seq'::regclass),
  bulk_upload_id integer,
  sku_id character varying(2500),
  shop_id character varying(2500),
  admin_id integer,
  organisation_id integer NOT NULL,
  image_url character varying(2500),
  status USER-DEFINED DEFAULT 'pending'::error_image_inputs_status,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE image_check_result (
  id integer NOT NULL DEFAULT nextval('image_check_result_id_seq'::regclass),
  assigned_survey_id integer,
  admin_id integer,
  organisation_id integer NOT NULL,
  image character varying(2500),
  dimensions jsonb,
  metadata jsonb,
  pip_access boolean DEFAULT true,
  full_frame_detection boolean DEFAULT true,
  is_real_pic boolean NOT NULL DEFAULT true,
  is_full_frame boolean NOT NULL DEFAULT true,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE image_collections (
  id integer NOT NULL DEFAULT nextval('image_collections_id_seq'::regclass),
  admin_id integer,
  surveyor_id integer,
  shop_id integer,
  service_id integer,
  metadata jsonb,
  photos_taken jsonb,
  status USER-DEFINED DEFAULT 'selected'::collected_image_status_types,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  organisation_id integer,
  feedback_metadata jsonb,
  feedback_status USER-DEFINED DEFAULT 'no_feedback'::feedback_status_types,
  thumb jsonb,
  image_from USER-DEFINED DEFAULT 'recognition'::image_from_types,
  cooler_id integer,
  planogram_id integer,
  report character varying(2500)
);

CREATE TABLE image_container_brand_shares (
  id integer NOT NULL DEFAULT nextval('image_container_brand_shares_id_seq'::regclass),
  image_collection_id integer,
  brand_name character varying(255) NOT NULL,
  products_count integer DEFAULT 0,
  facing_count integer DEFAULT 0,
  percent_share double precision DEFAULT 0,
  percent_share_without_es double precision DEFAULT 0,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE image_container_doors (
  id integer NOT NULL DEFAULT nextval('image_container_doors_id_seq'::regclass),
  image_collection_id integer,
  image_container_id integer,
  name character varying(255),
  door_visible boolean DEFAULT false,
  metadata jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE image_container_product_shares (
  id integer NOT NULL DEFAULT nextval('image_container_product_shares_id_seq'::regclass),
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
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE image_container_products (
  id integer NOT NULL DEFAULT nextval('image_container_products_id_seq'::regclass),
  image_collection_id integer,
  image_container_section_id integer,
  name character varying(255),
  position integer,
  sku_code character varying(255),
  stack_size integer,
  confidence character varying(255),
  metadata jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  shelf integer,
  owner character varying(20),
  area double precision,
  ppm boolean DEFAULT false,
  ptm boolean DEFAULT false,
  ptm_reason character varying(255),
  ptm_suggestion text,
  ppm_metadata jsonb
);

CREATE TABLE image_container_sections (
  id integer NOT NULL DEFAULT nextval('image_container_sections_id_seq'::regclass),
  image_collection_id integer,
  image_container_door_id integer,
  name character varying(255),
  position integer,
  metadata jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
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

CREATE TABLE image_container_stacks (
  id integer NOT NULL DEFAULT nextval('image_container_stacks_id_seq'::regclass),
  image_collection_id integer,
  image_container_product_id integer,
  name character varying(255),
  position integer,
  sku_code character varying(255),
  stack_size integer,
  confidence character varying(255),
  metadata jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  shelf integer,
  owner character varying(20),
  ppm boolean DEFAULT false,
  ptm boolean DEFAULT false,
  ptm_reason character varying(255),
  ptm_suggestion text,
  ppm_metadata jsonb
);

CREATE TABLE image_containers (
  id integer NOT NULL DEFAULT nextval('image_containers_id_seq'::regclass),
  image_collection_id integer,
  image_metadata_id integer,
  name character varying(255),
  metadata jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
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

CREATE TABLE image_metadatas (
  id integer NOT NULL DEFAULT nextval('image_metadatas_id_seq'::regclass),
  image_collection_id integer,
  height integer,
  width integer,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE logs (
  id integer NOT NULL DEFAULT nextval('logs_id_seq'::regclass),
  level integer,
  message text,
  stack text,
  timestamp timestamp with time zone,
  context jsonb,
  status character varying(2500) DEFAULT 'unchecked'::character varying,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE models (
  id integer NOT NULL DEFAULT nextval('models_id_seq'::regclass),
  organisation_id integer NOT NULL,
  name character varying(2500),
  url text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE muse_planograms (
  id integer NOT NULL DEFAULT nextval('muse_planograms_id_seq'::regclass),
  admin_id integer,
  cooler_id integer,
  organisation_id integer NOT NULL,
  name character varying(2500),
  image character varying(2500),
  metadata jsonb,
  status USER-DEFINED DEFAULT 'active'::cooler_status,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
  id integer NOT NULL DEFAULT nextval('notifications_id_seq'::regclass),
  notification_id character varying(2500),
  admin_id integer,
  title character varying(2500),
  message text,
  progress character varying,
  tag character varying(2500),
  details jsonb,
  read boolean DEFAULT false,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE organisations (
  id integer NOT NULL DEFAULT nextval('organisations_id_seq'::regclass),
  organisation_id character varying(2500) NOT NULL,
  name character varying(2500) NOT NULL,
  short_name character varying(2500),
  logo_url text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  type character varying(255) DEFAULT 'client'::character varying,
  pip_access boolean DEFAULT true,
  vti_access boolean DEFAULT true,
  geofencing boolean DEFAULT true,
  brand_owner_name character varying(2500),
  full_frame_detection boolean DEFAULT true
);

CREATE TABLE planograms (
  id integer NOT NULL DEFAULT nextval('planograms_id_seq'::regclass),
  admin_id integer,
  cooler_id integer,
  organisation_id integer NOT NULL,
  name character varying(2500),
  image character varying(2500),
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  metadata jsonb,
  products jsonb,
  status USER-DEFINED DEFAULT 'active'::cooler_status
);

CREATE TABLE poc_image (
  id integer NOT NULL DEFAULT nextval('poc_image_id_seq'::regclass),
  admin_id integer,
  meta_data jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE poc_images (
  id integer NOT NULL DEFAULT nextval('poc_images_id_seq'::regclass),
  admin_id integer,
  image_id integer,
  image character varying,
  meta_data jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE questions (
  id integer NOT NULL DEFAULT nextval('questions_id_seq'::regclass),
  question_id character varying(2500) NOT NULL,
  survey_id integer,
  images jsonb,
  content character varying(2500) NOT NULL,
  type USER-DEFINED DEFAULT 'short_answer'::question_types,
  options jsonb,
  required boolean DEFAULT false,
  status USER-DEFINED DEFAULT 'active'::survey_status_types,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE recognition_jobs (
  id integer NOT NULL DEFAULT nextval('recognition_jobs_id_seq'::regclass),
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
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  error_message character varying(2500)
);

CREATE TABLE responses (
  id integer NOT NULL DEFAULT nextval('responses_id_seq'::regclass),
  r_id character varying(2500) NOT NULL,
  assigned_survey_id integer,
  question_id integer,
  response character varying,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roboflow_projects (
  id integer NOT NULL DEFAULT nextval('roboflow_projects_id_seq'::regclass),
  start_date date NOT NULL,
  end_date date NOT NULL,
  project_name text NOT NULL,
  project_id text NOT NULL
);

CREATE TABLE role_accesses (
  id integer NOT NULL DEFAULT nextval('role_accesses_id_seq'::regclass),
  role_id integer,
  access_to USER-DEFINED NOT NULL,
  access_type USER-DEFINED DEFAULT 'view_access'::access_types,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
  id integer NOT NULL DEFAULT nextval('roles_id_seq'::regclass),
  role_id character varying(2500) NOT NULL,
  admin_id integer,
  organisation_id integer NOT NULL,
  name character varying(2500),
  short_name character varying(2500),
  description text,
  portal_access jsonb DEFAULT '["mobile_portal", "web_portal"]'::jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE scheduled_visits (
  id integer NOT NULL DEFAULT nextval('scheduled_visits_new_id_seq'::regclass),
  shop_id integer NOT NULL,
  organisation_id integer NOT NULL,
  route_id character varying(2500),
  frequency USER-DEFINED DEFAULT 'weekly'::visit_frequency_types,
  monday boolean NOT NULL DEFAULT false,
  tuesday boolean NOT NULL DEFAULT false,
  wednesday boolean NOT NULL DEFAULT false,
  thursday boolean NOT NULL DEFAULT false,
  friday boolean NOT NULL DEFAULT false,
  saturday boolean NOT NULL DEFAULT false,
  sunday boolean NOT NULL DEFAULT false,
  start_date date,
  last_performed_on date,
  next_due_date date,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now()
);

CREATE TABLE shelf_ex_skus (
  id integer NOT NULL DEFAULT nextval('shelf_ex_skus_id_seq'::regclass),
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
  status USER-DEFINED DEFAULT 'pending'::sku_status_types,
  color character varying(2500),
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  product_depth character varying(2500),
  is_stackable boolean DEFAULT false
);

CREATE TABLE shops (
  id integer NOT NULL DEFAULT nextval('shops_id_seq'::regclass),
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
  status USER-DEFINED DEFAULT 'active'::shop_status_types,
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  company_shop_id character varying(2500),
  latitude double precision,
  longitude double precision,
  key character varying(2500),
  unit_id integer
);

CREATE TABLE skus (
  id integer NOT NULL DEFAULT nextval('skus_id_seq'::regclass),
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
  status USER-DEFINED DEFAULT 'pending'::sku_status_types,
  review_notes text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  pack_category character varying(2500),
  pack_type character varying(2500),
  shelf_ex_sku_id character varying
);

CREATE TABLE spatial_ref_sys (
  srid integer NOT NULL,
  auth_name character varying(256),
  auth_srid integer,
  srtext character varying(2048),
  proj4text character varying(2048)
);

CREATE TABLE special_accesses (
  id integer NOT NULL DEFAULT nextval('special_accesses_id_seq'::regclass),
  user_id integer,
  access_to USER-DEFINED NOT NULL,
  access_type USER-DEFINED DEFAULT 'view_access'::access_types,
  type USER-DEFINED NOT NULL,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE store_coolers (
  id integer NOT NULL DEFAULT nextval('store_coolers_id_seq'::regclass),
  admin_id integer,
  shop_id integer,
  cooler_id integer
);

CREATE TABLE store_planograms (
  id integer NOT NULL DEFAULT nextval('store_planograms_id_seq'::regclass),
  admin_id integer,
  shop_id integer,
  planogram_id integer
);

CREATE TABLE surveys (
  id integer NOT NULL DEFAULT nextval('surveys_id_seq'::regclass),
  survey_id character varying(2500) NOT NULL,
  admin_id integer,
  organisation_id integer NOT NULL,
  description character varying(2500),
  title character varying(2500),
  status USER-DEFINED DEFAULT 'active'::survey_status_types,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE task_assignment_failures (
  id integer NOT NULL DEFAULT nextval('task_assignment_failures_id_seq'::regclass),
  admin_id integer,
  reason text,
  error text,
  date character varying(255),
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE thumbnails (
  id integer NOT NULL DEFAULT nextval('thumbnails_id_seq'::regclass),
  admin_id integer,
  sku_id character varying,
  thumbnail character varying(2500),
  type USER-DEFINED DEFAULT 'front'::thumbnail_views,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE units (
  id integer NOT NULL DEFAULT nextval('units_id_seq'::regclass),
  unit_code character varying(2500),
  organisation_id integer NOT NULL,
  unit_head_id integer,
  unit_name character varying(2500) NOT NULL,
  pip_access boolean DEFAULT true,
  vti_access boolean DEFAULT true,
  geofencing USER-DEFINED DEFAULT 'soft_alert'::geofencing_types,
  geofencing_radius integer DEFAULT 100,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  full_frame_detection boolean DEFAULT true
);

CREATE TABLE user_activity (
  id integer NOT NULL DEFAULT nextval('user_activity_id_seq'::regclass),
  admin_id character varying,
  portal_type USER-DEFINED NOT NULL,
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

CREATE TABLE user_routes (
  id integer NOT NULL DEFAULT nextval('user_routes_id_seq'::regclass),
  admin_id integer,
  route_id character varying,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  organisation_id integer
);

CREATE TABLE visits (
  id integer NOT NULL DEFAULT nextval('visits_id_seq'::regclass),
  visit_id character varying(2500) NOT NULL,
  visit_name character varying(2500),
  survey_id integer,
  admin_id integer,
  surveyor_id integer,
  organisation_id integer NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  status USER-DEFINED DEFAULT 'pending'::assigned_survey_status_types,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Enum types:
-- access_to_types: 'roles', 'employees', 'surveys', 'sku', 'shops', 'special_access', 'schedule_visits', 'planogram'
-- access_types: 'full_access', 'view_access', 'no_access'
-- assigned_survey_reason_logs_status_types: 'NO_LOCATION_PROVIDED', 'LOCATION_PROVIDED_NOT_UPDATED', 'LOCATION_PROVIDED_UPDATED', 'LOCATION_PROVIDED_REJECTED'
-- assigned_survey_status_types: 'pending', 'in_progress', 'completed', 'cancelled', 'missed', 'blocked'
-- bulk_upload_status: 'preparing', 'queued', 'processing', 'paused', 'completed', 'failed', 'stopped'
-- collected_image_status_types: 'selected', 'rejected'
-- cooler_status: 'active', 'deleted'
-- error_image_inputs_status: 'pending', 'corrected'
-- feedback_status_types: 'no_feedback', 'on_review', 'rejected', 'accepted'
-- gender_types: 'male', 'female', 'other', 'prefer_not_to_say'
-- geofencing_types: 'no_alert', 'soft_alert', 'hard_alert'
-- image_from_types: 'recognition', 'collection'
-- portal_types: 'web_portal', 'mobile_portal'
-- question_types: 'short_answer', 'long_answer', 'multiple_choice', 'checkbox', 'location', 'number', 'email', 'phone', 'link', 'date', 'time', 'rating'
-- shop_status_types: 'active', 'deleted'
-- sku_status_types: 'pending', 'draft', 'active', 'in_progress', 'completed', 'cancelled', 'rejected', 'deleted'
-- special_access_types: 'allow', 'deny'
-- survey_status_types: 'active', 'deleted'
-- thumbnail_views: 'front', 'back', 'left', 'right', 'top', 'bottom', 'front_top_left', 'front_top_right', 'front_bottom_left', 'front_bottom_right', 'back_top_left', 'back_top_right', 'back_bottom_left', 'back_bottom_right'
-- user_status_types: 'active', 'inactive', 'deleted'
-- user_types: 'superAdmin', 'organisationHead', 'employee'
-- visit_frequency_types: 'fortnightly', 'weekly'
