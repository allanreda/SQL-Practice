-- For our first foray into aggregates, we're going to stick to something simple. 
-- We want to know how many facilities exist - simply produce a total count.
select 
	count(*) 
from 
	cd.facilities;

-- Produce a count of the number of facilities that have a cost to guests of 10 or more.
select 
	count(*)
from 
	cd.facilities
where 
	guestcost >= 10;

-- Produce a count of the number of recommendations each member has made. Order by member ID.
select 
	recommendedby, 
	count(*) 
from 
	cd.members
where 
	recommendedby is not null
group by 
	recommendedby
order by 
	recommendedby;   

-- Produce a list of the total number of slots booked per facility. 
-- For now, just produce an output table consisting of facility id and slots, sorted by facility id.
select 
	facid, 
	sum(slots) as total_slots
from 
	cd.bookings
group by 
	facid
order by 
	facid;

-- Produce a list of the total number of slots booked per facility in the month of September 2012. 
-- Produce an output table consisting of facility id and slots, sorted by the number of slots.
select 
	facid, 
	sum(slots) as total_slots
from 
	cd.bookings
where 
	starttime >= '2012-09-01' and 
	starttime < '2012-10-01'
group by 
	facid
order by 
	total_slots asc;

-- Produce a list of the total number of slots booked per facility per month in the year of 2012. 
-- Produce an output table consisting of facility id and slots, sorted by the id and month.
select 
	facid, 
	extract(month from starttime) as month,
	sum(slots) as total_slots 
from 
	cd.bookings
where 
	extract(year from starttime) = 2012
group by 
	facid, 
	month
order by 
	facid, 
	month;

-- Find the total number of members (including guests) who have made at least one booking.
select 
	count(distinct(memid))
from 
	cd.bookings
where 
	slots >= 1

-- Produce a list of facilities with more than 1000 slots booked. 
-- Produce an output table consisting of facility id and slots, sorted by facility id.
select 
	facid, 
	sum(slots) as total_slots
from 
	cd.bookings
group by 
	facid
having 
	sum(slots) > 1000
order by 
	facid;
