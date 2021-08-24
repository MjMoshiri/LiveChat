-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL,
    user_name TEXT NOT NULL UNIQUE
);
CREATE TABLE rooms (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    title TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    admin_id UUID DEFAULT uuid_generate_v4() NOT NULL,
    link TEXT NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES users (id) 
);
CREATE TABLE messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    room_id UUID NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    user_id UUID NOT NULL,
    user_name TEXT NOT NULL
);
CREATE INDEX messages_room_id_index ON messages (room_id);
CREATE INDEX messages_user_id_index ON messages (user_id);
CREATE TABLE room_users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    room_id UUID NOT NULL
);
CREATE INDEX room_users_user_id_index ON room_users (user_id);
CREATE INDEX room_users_room_id_index ON room_users (room_id);
ALTER TABLE messages ADD CONSTRAINT messages_ref_room_id FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE;
ALTER TABLE messages ADD CONSTRAINT messages_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE room_users ADD CONSTRAINT room_users_ref_room_id FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE;
ALTER TABLE room_users ADD CONSTRAINT room_users_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE rooms ADD CONSTRAINT rooms_ref_admin_id FOREIGN KEY (admin_id) REFERENCES users (id) ON DELETE CASCADE;
