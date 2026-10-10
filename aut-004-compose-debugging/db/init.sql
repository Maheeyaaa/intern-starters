CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
INSERT INTO items (name) VALUES ('widget'), ('gadget'), ('gizmo');
