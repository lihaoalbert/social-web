ALTER TABLE `social-dev`.monitor_messages MODIFY COLUMN WID BIGINT NOT NULL;
ALTER TABLE `social-dev`.monitor_messages MODIFY COLUMN reposts_count BIGINT;
ALTER TABLE `social-dev`.monitor_messages MODIFY COLUMN comments_count BIGINT;

ALTER TABLE `social-dev`.display_messages MODIFY COLUMN WID BIGINT NOT NULL;
ALTER TABLE `social-dev`.display_messages MODIFY COLUMN wuser_id BIGINT NOT NULL;

ALTER TABLE `social-dev`.upload_messages MODIFY COLUMN Wbid BIGINT;

ALTER TABLE `social-dev`.userkeys MODIFY COLUMN UID BIGINT NOT NULL;

ALTER TABLE `social-dev`.username_selects MODIFY COLUMN UID BIGINT NOT NULL;

ALTER TABLE `social-dev`.display_messages MODIFY COLUMN WID BIGINT NOT NULL;
ALTER TABLE `social-dev`.display_messages MODIFY COLUMN wuser_id BIGINT;

ALTER TABLE `social-dev`.monitor_messages MODIFY COLUMN WID BIGINT NOT NULL;
ALTER TABLE `social-dev`.monitor_messages MODIFY COLUMN reposts_count BIGINT;
ALTER TABLE `social-dev`.monitor_messages MODIFY COLUMN comments_count BIGINT;

ALTER TABLE `social-dev`.monitor_users MODIFY COLUMN UID BIGINT NOT NULL;

ALTER TABLE `social-dev`.friend_followers MODIFY COLUMN UID BIGINT NOT NULL;

ALTER TABLE `social-dev`.user_friend_followers MODIFY COLUMN UID BIGINT NOT NULL;
ALTER TABLE `social-dev`.user_friend_followers MODIFY COLUMN source_UID BIGINT NOT NULL;
ALTER TABLE `social-dev`.user_friend_followers MODIFY COLUMN follower_friend_UID BIGINT NOT NULL;

ALTER TABLE `social-dev`.monitor_messages_displays MODIFY COLUMN WID BIGINT NOT NULL;
ALTER TABLE `social-dev`.monitor_messages_displays MODIFY COLUMN reposts_count BIGINT;
ALTER TABLE `social-dev`.monitor_messages_displays MODIFY COLUMN comments_count BIGINT;
