DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;

CREATE TABLE users (
  id integer primary key autoincrement,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id integer primary key autoincrement,
  title VARCHAR(255) NOT NULL,
  body text NOT NULL,
  user_id integer references users(id)
);

CREATE TABLE question_follows (
  id integer primary key autoincrement,
  question_id integer references questions(id),
  user_id integer references users(id)
);

CREATE TABLE replies (
  id integer primary key autoincrement,
  question_id integer references questions(id),
  reply_id integer references replies(id),
  user_id integer references users(id),
  body text NOT NULL
);

CREATE TABLE question_likes (
  id integer primary key autoincrement,
  user_id integer references users(id),
  question_id integer references questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Haseeb', 'Qureshi'),
  ('Zachary', 'Reisman');

INSERT INTO
  questions
VALUES
  (1, 'When is lunch?', 'Please let lunch come soon? Please?', 2),
  (2, 'Hey man', 'Second comment', 2),
  (3, 'Lets get chinese', 'Third comment', 2),
  (4, 'No', 'Fourth comment', 2),
  (5, 'I dont know', 'Fifth comment', 2),
  (6, 'When is lunch today', '6 comment', 1);


INSERT INTO
  question_follows
VALUES
  (1, 1, 1);

INSERT INTO
  replies
VALUES
  (1, 1, NULL, 1, '); DROP TABLES; ');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 5),
  (1, 4),
  (2, 2),
  (2, 3),
  (2, 5),
  (2, 4);
