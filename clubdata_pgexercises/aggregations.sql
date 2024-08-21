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

-- Produce a list of facilities along with their total revenue. The output table should consist of facility name 
-- and revenue, sorted by revenue. Remember that there's a different cost for guests and members!
select 
	fac.name, 
	sum(slots * case when
	    bks.memid = 0 then fac.guestcost
	    else fac.membercost end) as revenue
from 
	cd.facilities as fac
inner join
	cd.bookings as bks
on 
	bks.facid = fac.facid
group by 
	fac.name
order by 
	revenue asc;

-- Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of 
-- facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!

select 
	fac.name, 
	sum(slots * case when
	    bks.memid = 0 then fac.guestcost
	    else fac.membercost end) as revenue
from 
	cd.facilities as fac
inner join
	cd.bookings as bks
on 
	bks.facid = fac.facid
group by 
	fac.name
having sum(slots * case when
	    bks.memid = 0 then fac.guestcost
	    else fac.membercost end) < 1000
order by 
	revenue;

-- or:

select 
	name, 
	revenue 
	from (
	select 
	fac.name, 
	sum(slots * case when
	    bks.memid = 0 then fac.guestcost
	    else fac.membercost end) as revenue
	from 
	    cd.facilities as fac
    inner join
	    cd.bookings as bks
    on 
	    bks.facid = fac.facid
	group by fac.name
) as subquery
where 
	revenue < 1000
order by 
	revenue asc;

-- Output the facility id that has the highest number of slots booked. For bonus points, try a version without a LIMIT clause. 
-- This version will probably look messy!
select 
	facid, 
	sum(slots) as total_slots
from 
	cd.bookings
group by 
	facid
order by 
	total_slots desc
limit 1;

-- or:

with sum as 
	(select 
	facid, 
	sum(slots) as totalslots
from 
	cd.bookings
group by 
	facid
)
select 
	facid, 
	totalslots 
from 
	sum
where 
	totalslots = (select max(totalslots) from sum);

-- Produce a list of the total number of slots booked per facility per month in the year of 2012. In this version, 
-- include output rows containing totals for all months per facility, and a total for all months for all facilities. 
-- The output table should consist of facility id, month and slots, sorted by the id and month. 
-- When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.
select 
	facid, 
	extract(month from starttime) as month, 
	sum(slots) as slots
from 
	cd.bookings
where 
	starttime >= '2012-01-01'
	and starttime < '2013-01-01'
group by rollup(
	facid, 
	month)
order by 
	facid, 
	month;

-- Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. 
-- The output table should consist of the facility id, name, and hours booked, sorted by facility id. 
-- Try formatting the hours to two decimal places.
select 
	fac.facid, 
	fac.name, 
	sum(bks.slots / 2.0) as total_hours
from 
	cd.bookings as bks
inner join 
	cd.facilities as fac
on 
	fac.facid = bks.facid
group by 
	fac.facid, 
	fac.name
order by 
	fac.facid;

-- Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
select 
	mem.surname, 
	mem.firstname, 
	mem.memid, 
	min(bks.starttime) as starttime
from 
	cd.bookings as bks
inner join 
	cd.members as mem
on 
	bks.memid = mem.memid
where 
	bks.starttime > '2012-09-01'
group by
	mem.surname, 
	mem.firstname, 
	mem.memid
order by 
	mem.memid;

-- Produce a list of member names, with each row containing the total member count. 
-- Order by join date, and include guest members.
