create table users
(
    id bigserial not null primary key,
    fname text not null,
    lname text
);

create table questions
(
    id bigserial not null primary key,
    title text not null,
    body text not null,
    author_id bigserial not null,

    foreign key (author_id) references users(id)
);

create table question_follows
(
    id bigserial not null primary key,
    question_id bigserial not null,
    user_id bigserial not null,

    foreign key (question_id) references questions(id),
    foreign key (users_id) references userss(id)
);

create table replies
(
    id bigserial not null primary key,
    question_id bigserial not null,
    parent_id bigserial,
    body text not null,


    foreign key (question_id) references questions(id),
    foreign key (parent_id) references replies(id)
);

create table question_likes
(
    id bigserial not null primary key,
    question_id bigserial not null,
    user_id bigserial not null,

    foreign key (question_id) references questions(id),
    foreign key (users_id) references userss(id)
)
