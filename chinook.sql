--non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
select c.CustomerId, c.FirstName, c.LastName, c.Country
from Customer c
where c.Country != "USA";

--brazil_customers.sql: Provide a query only showing the Customers from Brazil.
select c.CustomerId, c.FirstName, c.LastName, c.Country
from Customer c
where c.Country = "Brazil";

--brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
select c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
from Customer c, Invoice i
where c.Country = "Brazil"
and c.CustomerId = i.CustomerId;

--sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
select *
from Employee e
where e.Title = "Sales Support Agent";

--unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
select distinct i.BillingCountry
from Invoice i

--sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
select s.EmployeeId, s.FirstName || " " ||s.LastName "Full Name", i.InvoiceId, i.CustomerId, i.InvoiceDate
from Employee s, Invoice i, Customer c
where s.EmployeeId = c.SupportRepId

--invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
select 
	i.Total, 
	c.FirstName "Customer First Name", 
	c.LastName "Customer Last Name", 
	e.FirstName "Agent First Name", 
	e.LastName "Agent Last Name"
from Invoice i, Customer c, Employee e
where c.SupportRepId = e.EmployeeId 
and i.Customerid = c.Customerid

--total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?
select count(i.InvoiceId) NumberofInvoices,
	strftime('%Y' , i.InvoiceDate) as InvoiceYear
from Invoice i
where InvoiceYear = '2011' 
or InvoiceYear = "2009"
group by InvoiceYear

--total_sales_{year}.sql: What are the respective total sales for each of those years?
select '$' || sum(i.Total) Total,
	strftime('%Y', i.InvoiceDate) as InvoiceYear
from Invoice i
where InvoiceYear = "2011"
or InvoiceYear = "2009"
group by InvoiceYear;

--invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.

select count(InvoiceLineId)
from InvoiceLIne 
where InvoiceId = 37;

--line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
select InvoiceId, count(InvoiceLineId) Count
from InvoiceLine
group by InvoiceId
order by Count desc;

--line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
select i.InvoiceLineId, i.InvoiceId, i.UnitPrice, i.TrackId, i.Quantity, t.Name
from InvoiceLine i, Track t
where i.TrackId = t.TrackId;

--line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
select  i.*, t.Name, a.Name
from InvoiceLine i, Track t, Artist a, Album al
where i.TrackId = t.TrackId
and t.AlbumId = al.AlbumId
and al.ArtistId = a.ArtistId;

--country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY
select BillingCountry, count(InvoiceId)
from Invoice
group by BillingCountry

--playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
select p.Name ,pl.PlaylistId, count(pl.TrackId)
from PlaylistTrack pl, Playlist p
where pl.PlaylistId = p.PlaylistId
group by pl.PlayListId;

--tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
select t.Name "Track", al.Title "Album Titile", m.Name "Media Type", g.Name "Genre"
from Track t, Album al, MediaType m, Genre g
where t.GenreId = g.GenreId
and t.AlbumId = al.AlbumId
and t.MediaTypeId = m.MediaTypeId;

--invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
select *, count(il.InvoicelineId) "number of line items"
from Invoice i, InvoiceLine il
 where i.InvoiceId = il.InvoiceId
 group by i.invoiceid;

--sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
select e.FirstName || " " || e.LastName "NAME", sum(i.Total) "TOTAL SALES"
from Employee e, Invoice i, Customer c
where c.SupportRepId = e.EmployeeId
and i.Customerid = c.customerid
group by e.employeeid;

--top_2009_agent.sql: Which sales agent made the most in sales in 2009?

select Totals.FirstName || " " || Totals.LastName "Name", max(Totals.TotalSales)
From 
	(select e.FirstName, e.LastName, sum(i.Total) as "TotalSales"
	from Employee e, Invoice i, Customer c
	where i.CustomerId = c.CustomerId
	and c.SupportRepId = e.EmployeeId
	and i.InvoiceDate like "2009%"
	group by e.LastName) 
as "Totals";

--Hint: Use the MAX function on a subquery.
--top_agent.sql: Which sales agent made the most in sales over all?
select Totals.FirstName, Totals.Lastname, max(Totals.TotalSales)
from (select e.FirstName, e.LastName, sum(i.Total) "TotalSales"
from Employee e, Invoice i, Customer c
where c.SupportRepId = e.EmployeeId
and i.Customerid = c.customerid
group by e.employeeid) as "Totals";

--sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
select e.FirstName, e.LastName, count(c.SupportRepId) as "Number of Customers Assigned"
from Employee e, Customer c
where c.SupportRepId = e.EmployeeId
group by e.employeeId;

--sales_per_country.sql: Provide a query that shows the total sales per country.
select BillingCountry, sum(Total) as "TotalSalesPerCountry"
from Invoice
group by BillingCountry;

--top_country.sql: Which country's customers spent the most?
select Totals.BillingCountry, max(Totals.TotalSalesPerCountry)
from (select BillingCountry, sum(Total) as "TotalSalesPerCountry"
from Invoice
group by BillingCountry) as "Totals";

--top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
select Totals.TrackId, max(Totals.MostPurchased)
from (select il.TrackId "TrackId", count(il.TrackId) as "MostPurchased"
from InvoiceLIne il, Invoice i, Track t
where i.InvoiceDate like "2013%"
group by TrackId) as "Totals";

--top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.
select t.Name, count (t.Name) PurchaseCount 
from Track t 
join Invoiceline l on l.TrackId = t.TrackId
group by t.name
order by purchasecount desc
limit 5;
