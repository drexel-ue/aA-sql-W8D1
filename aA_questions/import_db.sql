PRAGMA foreign_keys = ON;

drop table if exists question_follows;
drop table if exists replies;
drop table if exists question_likes;
drop table if exists users;
drop table if exists questions;

create table users
(
    id integer primary key,
    fname text not null,
    lname text
);

create table questions
(
    id integer primary key,
    title text not null,
    body text not null,
    author_id integer not null,

    foreign key (author_id) references users(id)
);

create table question_follows
(
    id integer primary key,
    question_id integer not null,
    user_id integer not null,

    foreign key (question_id) references questions(id),
    foreign key (user_id) references users(id)
);

create table replies
(
    id integer primary key,
    user_id integer not null,
    question_id integer not null,
    parent_id integer,
    body text not null,


    foreign key (question_id) references questions(id),
    foreign key (user_id) references users(id),
    foreign key (parent_id) references replies(id)
);

create table question_likes
(
    id integer primary key,
    question_id integer not null,
    user_id integer not null,

    foreign key (question_id) references questions(id),
    foreign key (user_id) references users(id)
);

-- User Inserts
insert into users
    (fname, lname)
values
    ('Thea', 'Sweetland'),
    ('Maureen', 'Perrottet'),
    ('Frannie', 'Tuttle'),
    ('Phillida', 'Bewley'),
    ('Jo', 'Blindermann');

-- Question Inserts
insert into questions
    (author_id, title, body)
values
    (1, 'Goodbye Lover', 'yviscwkerwunlpwp'),
    (2, 'Sweetest Thing, The', 'ocbsdahuugsyhwwi'),
    (3, 'Girl, The', 'asgpsrcasobukpza'),
    (4, 'Meet the Fockers', 'mjkgyjphkldyuciu'),
    (5, 'Après lui', 'ahyrlvxmewpimjkb');


-- Question_Follows Inserts
insert into question_follows
    (user_id, question_id)
 values
    (1, 5),
    (2, 4),
    (3, 1),
    (4, 2),
    (5, 3),
    (3, 5);

-- Replies Inserts
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('ofvqoiywuntyrkaj', null, 1, 5);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('ruhtoqprlbufoars', 1, 1, 2);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('txyfdffyonywcxlk', 2, 1, 3);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('kwubxlulsvtsmhno', null, 2, 4);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('jnrvdpjgmfhaustd', 4, 2, 3);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('jnrvdpjgmfhaustd', 5, 2, 1);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('jnrvdpjgmfhaustd', null, 5, 5);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('jnrvdpjgmfhaustd', null, 4, 4);
insert into replies
    (body, parent_id, question_id, user_id)
values
    ('jnrvdpjgmfhaustd', null, 3, 2);


-- Question Likes
insert into question_likes
    (question_id, user_id)
values(1, 2);
insert into question_likes
    (question_id, user_id)
values(1, 3);
insert into question_likes
    (question_id, user_id)
values(1, 4);
insert into question_likes
    (question_id, user_id)
values(1, 5);
insert into question_likes
    (question_id, user_id)
values(3, 3);
insert into question_likes
    (question_id, user_id)
values(3, 2);
insert into question_likes
    (question_id, user_id)
values(4, 1);

