class CreateCustomersView < ActiveRecord::Migration
  def up
    create_view_sql = "CREATE VIEW customers_view AS 
         select 
		    T1.id,
		    T1.UID,
		    T1.screen_name,
		    T1.name,
		    T1.province,
		    T2.Name as 'province_name',
		    T1.city,
		    T3.Name as 'city_name',
		    T1.location,
		    T1.profile_image_url,
		    T1.`domain`,
		    T1.gender,
		    T1.followers_count,
		    T1.friends_count,
		    T1.statuses_count,
		    T1.favourites_count,
		    T1.user_id,
		    T1.created_at
		  from username_selects T1
		  left join province_cities T2 on T1.province=T2.id
		  left join province_cities T3 on T1.city=T3.id
		"
    execute(create_view_sql)
  end

  def down
    drop_view_sql = "DROP VIEW customers_view"
    execute(drop_view_sql)
  end
end
