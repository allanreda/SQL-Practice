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
