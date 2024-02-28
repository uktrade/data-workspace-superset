BEGIN;

-- Ensure Editor role exists
INSERT INTO ab_role(id, name) VALUES (nextval('ab_role_id_seq'), 'Editor') ON CONFLICT DO NOTHING;

-- Delete any existing editor permissions
DELETE FROM ab_permission_view_role WHERE role_id = (
	SELECT id FROM ab_role WHERE name = 'Editor'
);

-- Create set of editor permissions
-- Since the id column is not serial/autoincrement, we call nextval on a sequence explicitly
WITH required_permissions(new_permission_view_role_id, permission_name, view_menu_name) AS (
	VALUES
		-- From built-in Gamma role
		(nextval('ab_permission_view_role_id_seq'), 'can_add', 'FilterSets'),
		(nextval('ab_permission_view_role_id_seq'), 'can_add', 'Tags'),
		(nextval('ab_permission_view_role_id_seq'), 'can_bulk_create', 'Tag'),
		(nextval('ab_permission_view_role_id_seq'), 'can_csv', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_dashboard', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_dashboard_permalink', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_delete', 'FilterSets'),
		(nextval('ab_permission_view_role_id_seq'), 'can_delete', 'Tags'),
		(nextval('ab_permission_view_role_id_seq'), 'can_delete_embedded', 'Dashboard'),
		(nextval('ab_permission_view_role_id_seq'), 'can_download', 'Tags'),
		(nextval('ab_permission_view_role_id_seq'), 'can_edit', 'FilterSets'),
		(nextval('ab_permission_view_role_id_seq'), 'can_edit', 'Tags'),
		(nextval('ab_permission_view_role_id_seq'), 'can_estimate_query_cost', 'SQLLab'),
		(nextval('ab_permission_view_role_id_seq'), 'can_explore', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_explore_json', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_export', 'Chart'),
		(nextval('ab_permission_view_role_id_seq'), 'can_export', 'Dashboard'),
		(nextval('ab_permission_view_role_id_seq'), 'can_external_metadata', 'Datasource'),
		(nextval('ab_permission_view_role_id_seq'), 'can_external_metadata_by_name', 'Datasource'),
		(nextval('ab_permission_view_role_id_seq'), 'can_fetch_datasource_metadata', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_format_sql', 'SQLLab'),
		(nextval('ab_permission_view_role_id_seq'), 'can_get', 'Datasource'),
		(nextval('ab_permission_view_role_id_seq'), 'can_get', 'MenuApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_get', 'OpenApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_get_embedded', 'Dashboard'),
		(nextval('ab_permission_view_role_id_seq'), 'can_get_value', 'KV'),
		(nextval('ab_permission_view_role_id_seq'), 'can_import_dashboards', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_invalidate', 'CacheRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_list', 'AsyncEventsRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_list', 'DynamicPlugin'),
		(nextval('ab_permission_view_role_id_seq'), 'can_list', 'FilterSets'),
		(nextval('ab_permission_view_role_id_seq'), 'can_list', 'SavedQuery'),
		(nextval('ab_permission_view_role_id_seq'), 'can_list', 'Tags'),
		(nextval('ab_permission_view_role_id_seq'), 'can_log', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_profile', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_query', 'Api'),
		(nextval('ab_permission_view_role_id_seq'), 'can_query_form_data', 'Api'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'AdvancedDataType'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'AvailableDomains'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Chart'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Dashboard'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'DashboardFilterStateRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'DashboardPermalinkRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Database'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Dataset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'EmbeddedDashboard'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Explore'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'ExploreFormDataRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'ExplorePermalinkRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Profile'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'RowLevelSecurity'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'SecurityRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Tag'),
		(nextval('ab_permission_view_role_id_seq'), 'can_recent_activity', 'Log'),
		(nextval('ab_permission_view_role_id_seq'), 'can_share_chart', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_share_dashboard', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_show', 'DynamicPlugin'),
		(nextval('ab_permission_view_role_id_seq'), 'can_show', 'SwaggerView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_show', 'Tags'),
		(nextval('ab_permission_view_role_id_seq'), 'can_slice', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_store', 'KV'),
		(nextval('ab_permission_view_role_id_seq'), 'can_tags', 'TagView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_this_form_get', 'ResetMyPasswordView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_this_form_post', 'ResetMyPasswordView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_time_range', 'Api'),
		(nextval('ab_permission_view_role_id_seq'), 'can_userinfo', 'UserRemoteUserModelView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'Chart'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'Dashboard'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'DashboardFilterStateRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'DashboardPermalinkRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'ExploreFormDataRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'ExplorePermalinkRestApi'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'Tag'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Charts'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Dashboards'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Data'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Databases'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Datasets'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Home'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Import Dashboards'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Plugins'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Tags'),

		-- From build-in sql_lab role
		-- The permissions do seem to be inconsistent with respect to case and spacing
		(nextval('ab_permission_view_role_id_seq'), 'can_activate', 'TabStateView'),
		-- Also in Gamme, removed to avoid integrity errors due to duplication
		-- (nextval('ab_permission_view_role_id_seq'), 'can_csv', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_delete', 'TabStateView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_delete_query', 'TabStateView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_execute_sql_query', 'SQLLab'),
		(nextval('ab_permission_view_role_id_seq'), 'can_export', 'SavedQuery'),
		(nextval('ab_permission_view_role_id_seq'), 'can_export_csv', 'SQLLab'),
		(nextval('ab_permission_view_role_id_seq'), 'can_get', 'TabStateView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_get_results', 'SQLLab'),
		(nextval('ab_permission_view_role_id_seq'), 'can_migrate_query', 'TabStateView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_my_queries', 'SqlLab'),
		(nextval('ab_permission_view_role_id_seq'), 'can_post', 'TabStateView'),
		(nextval('ab_permission_view_role_id_seq'), 'can_put', 'TabStateView'),
		-- Also in Gamme, removed to avoid integrity errors due to duplication
		-- (nextval('ab_permission_view_role_id_seq'), 'can_read', 'Database'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'Query'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'SavedQuery'),
		(nextval('ab_permission_view_role_id_seq'), 'can_read', 'SQLLab'),
		(nextval('ab_permission_view_role_id_seq'), 'can_sql_json', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_sqllab', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_sqllab_history', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_sqllab_table_viz', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_sqllab_viz', 'Superset'),
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'SavedQuery'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Query Search'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'Saved Queries'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'SQL Editor'),
		(nextval('ab_permission_view_role_id_seq'), 'menu_access', 'SQL Lab'),
		(nextval('ab_permission_view_role_id_seq'), 'stop_query', 'Superset'),

		-- To be able to access the database (we only have one database)
		(nextval('ab_permission_view_role_id_seq'), 'all_database_access', 'all_database_access'),

		-- To make a chart
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'Dataset'), 

		-- Without this, get 405 errors when the front end POSTs to the log
		(nextval('ab_permission_view_role_id_seq'), 'can_write', 'Log')
)

INSERT INTO ab_permission_view_role(id, permission_view_id, role_id)
	SELECT
		required_permissions.new_permission_view_role_id,
		ab_permission_view.id,
		ab_role.id
	FROM
		ab_permission_view
	INNER JOIN
		ab_permission ON
			ab_permission.id = ab_permission_view.permission_id
	INNER JOIN
		ab_view_menu ON
			ab_view_menu.id = ab_permission_view.view_menu_id
	INNER JOIN
		required_permissions ON
			required_permissions.permission_name = ab_permission.name
			AND required_permissions.view_menu_name = ab_view_menu.name
	INNER JOIN
		ab_role ON ab_role.name = 'Editor';

COMMIT;
