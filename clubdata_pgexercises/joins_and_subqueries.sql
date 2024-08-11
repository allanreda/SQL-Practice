-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
select bks.starttime
from 
	cd.bookings as bks
inner join 
	cd.members as mems
on 
	bks.memid = mems.memid
where 
	mems.firstname = 'David' and 
	mems.surname = 'Farrell';

-- How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
-- Return a list of start time and facility name pairings, ordered by the time.
select 
	bks.starttime as start, 
	fac.name
from 
	cd.bookings as bks
inner join 
	cd.facilities as fac
on 
	bks.facid = fac.facid
where 
	fac.name like '%Tennis Court%' and 
	bks.starttime >= '2012-09-21' and 
	bks.starttime < '2012-09-22'
order by 
	bks.starttime asc;

-- How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, 
-- and that results are ordered by (surname, firstname).
select distinct 
	mem.firstname, 
	mem.surname
from 
	cd.members as mem
inner join 
	cd.members as rec
on 
	mem.memid = rec.recommendedby
order by 
	mem.surname, 
	mem.firstname

-- How can you output a list of all members, including the individual who recommended them (if any)? 
-- Ensure that results are ordered by (surname, firstname).
select 
	mem.firstname as mem_firstname, 
	mem.surname as mem_surname, 
	rec.firstname as rec_firstname, 
	rec.surname as rec_surname
from 
	cd.members as mem
left outer join 
	cd.members as rec
on 
	rec.memid = mem.recommendedby
order by 
	mem_surname, 
	mem_firstname;

-- How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, 
-- and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name 
-- followed by the facility name.
select distinct
	concat(mem.firstname, ' ', mem.surname) as member, 
	fac.name as facility
from 
	cd.members as mem
inner join 
	cd.bookings as bks
on 
	mem.memid = bks.memid
inner join 
	cd.facilities as fac
on 
	bks.facid = fac.facid
where 
	fac.name like '%Tennis Court%'
order by 
	member, 
	facility;

-- How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? 
-- Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), 
-- and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted 
-- as a single column, and the cost. Order by descending cost, and do not use any subqueries.
select 
	concat(mem.firstname, ' ', mem.surname) as member, 
	fac.name as facility,
	case when 
	    mem.memid = 0 then bks.slots * fac.guestcost else
	    bks.slots * fac.membercost
	end as cost
from 
	cd.members as mem
inner join 
	cd.bookings as bks
on 
	mem.memid = bks.memid
inner join 
	cd.facilities as fac
on 
	bks.facid = fac.facid
where 
	bks.starttime > '2012-09-14' and 
	bks.starttime < '2012-09-15' and
	(case 
		when mem.memid = 0 then bks.slots * fac.guestcost 
		else bks.slots * fac.membercost
	end) > 30
order by 
	cost desc;

-- How can you output a list of all members, including the individual who recommended them (if any), without using any joins? 
-- Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.

select distinct 
	concat(mem.firstname, ' ', mem.surname) as member, 
	(select 
	       concat(rec.firstname, ' ', rec.surname) as recommender
	from 
	    cd.members as rec
	where 
	    rec.memid = mem.recommendedby
	)
from 
	cd.members as mem
order by 
	member;

