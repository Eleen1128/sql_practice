USE ig_app; 
show tables;
desc users;
desc photos;
select * from photos;
desc likes;
-- 1
-- 記得往後確認是否有一樣的排序
select * from users order by created_at limit 5;

-- 3
select photos.user_id, photos.id, users.id, users.username
from users left join photos
on users.id = photos.user_id
where photos.user_id is null;
-- order by photos.user_id;


select username,likes.photo_id, photos.user_id
from likes left join users
on users.id = likes.user_id
right join photos
on likes.photo_id = photos.id;

-- 4 方法1
select photo_id, count(*) as count, photos.user_id, username
from likes 
join photos
on likes.photo_id = photos.id
join users
on users.id = photos.user_id
group by photo_id order by count desc limit 1;
-- 4 方法2
select photo_id, count(*)
from likes
group by photo_id
order by count(*) desc; -- id 為 145 的照片
-- subquery
select photos.id, username
from photos
join users
on users.id = photos.user_id
where photos.id = (
select photo_id
from likes
group by photo_id
order by count(*) desc
limit 1
);

-- 5
DELIMITER //
create procedure popular_post()
BEGIN
    select photo_id, count(*) as count, photos.user_id, username
from likes 
join photos
on likes.photo_id = photos.id
join users
on users.id = photos.user_id
group by photo_id order by count desc;
END //
DELIMITER ;
call popular_post();
-- 6 陷阱:count(*)相同, limit 7
select tag_id, count(*), tag_name
from photo_tags 
join tags
on tags.id = photo_tags.tag_id
group by tag_id order by count(*) desc;
-- group by tag_name


select count(*) from photos;

select * from likes;
-- 7
select count(*) from photos;
select users.id, username, count(*)
from likes 
join users
on likes.user_id = users.id
group by likes.user_id
having count(*) = 257;

-- subquery
select count(*) from photos;
select users.id, username, count(*)
from likes 
join users
on likes.user_id = users.id
group by likes.user_id
having count(*) = (select count(*) from photos);
-- 8 方法1
select count(*) from users;
select count(*) from photos;
select (select count(*) from photos)/(select count(*) from users) as '平均數';

-- 8 方法2
select count(photos.id)/ count(distinct users.id)
from photos
right join users
on photos.user_id = users.id;

-- 2 方法1
-- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
SELECT WEEKDAY(created_at) as created_at_Day, count(*)
from users  group by created_at_Day order by count(*) desc;
-- 2 方法2
SELECT dayname(created_at) as created_at_Day, count(*)
from users  group by created_at_Day order by count(*) desc;

show warnings;
