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
	mem.firstname, 
	mem.surname