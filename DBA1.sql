-- Basic SELECT Statement: Write a query to fetch all columns from the vendors table.
-- Output Columns: All columns from the vendors table.
-- Order By: vendor_id
SELECT *
FROM vendors
ORDER BY vendor_id;

-- WHERE Clause: Write a query to fetch the vendor_name, vendor_phone, and vendor_city from the vendors table for vendors located in the state of 'CA'.
-- Output Columns: vendor_name, vendor_phone, vendor_city.
-- Order By: vendor_name
SELECT vendor_name, vendor_phone, vendor_city
FROM vendors
WHERE vendor_state = 'CA'
ORDER BY vendor_name;

-- Sorting Results Write a query to fetch the invoice_id, invoice_total, and invoice_date from the invoices table, sorted by invoice_total in descending order.
-- Output Columns: invoice_id, invoice_total, invoice_date.
SELECT invoice_id, invoice_total, invoice_date
FROM invoices
ORDER BY invoice_total DESC;

-- Limiting Results: Write a query to fetch the invoices with the  3rd to 9th lowest invoice_total from the invoices table.
-- Output Columns: invoice_id, invoice_total.
-- Order By: invoice_total
SELECT invoice_id, invoice_total
FROM invoices
ORDER BY invoice_total
LIMIT 7 OFFSET 2;

-- Using Arithmetic: Write a query to fetch the invoice_id, invoice_total, and the remaining balance (calculated as invoice_total - payment_total) for all invoices in the invoices table.
-- Output Columns: invoice_id, invoice_total, Remaining Balance
-- Order By: invoice_id
SELECT invoice_id, invoice_total, (invoice_total - payment_total) AS remaining_balance
FROM invoices
ORDER BY invoice_id;

-- Inner Join: Write a query to fetch the invoice_id, invoice_total, vendor_name, and vendor_phone for all invoices. Use an inner join between the invoices and vendors tables.
-- Output Columns: invoice_id, invoice_total, vendor_name, vendor_phone.
-- Order By: Invoice_id
SELECT i.invoice_id, i.invoice_total, v.vendor_name, v.vendor_phone
FROM invoices i
INNER JOIN vendors v ON i.vendor_id = v.vendor_id
ORDER BY i.invoice_id;

-- Outer Join: Write a query to fetch all vendor_name values along with the invoice_id. Include vendors who do not have any invoices. 
-- Output Columns: vendor_name, invoice_id
-- Order By: vendor_name
SELECT v.vendor_name, i.invoice_id
FROM vendors v
LEFT OUTER JOIN invoices i ON v.vendor_id = i.vendor_id
ORDER BY v.vendor_name;



-- Outer Join 2: Using the ex database; write a query to fetch all department_name values along with the employees last_name for each department. Include employees that do not have a matching department.
-- Output Columns: department_name, employee_last_name.
-- Order By: department_id
USE ex;
SELECT d.department_name, e.last_name AS employee_last_name
FROM departments d
LEFT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;
    
-- Using CONCAT Write a query to fetch a single column combining the first_name and last_name (formatted as "FirstName LastName") along with their vendor_name. Use the vendor_contacts and vendors tables.
-- Output Columns: Combined Contact Name, vendor_name.
-- Order By: Combined Contact Name
SELECT CONCAT(vc.first_name, ' ', vc.last_name) AS "Combined Contact Name", v.vendor_name
FROM vendor_contacts vc
JOIN vendors v ON vc.vendor_id = v.vendor_id
ORDER BY "Combined Contact Name";

-- Union: using the ex database; Write a query to fetch all unique first_name values from both the employees and sales_reps tables.
-- Output Columns: first_name.
-- Order By: first_name
USE ex;
SELECT first_name
FROM employees
UNION
SELECT first_name
FROM sales_reps
ORDER BY first_name;

-- Complex Query with Multiple Joins Write a query to fetch the invoice_id, invoice_total, vendor_name, and terms_description for all invoices. Use appropriate joins between the invoices, vendors, and terms tables.
-- Output Columns: invoice_id, invoice_total, vendor_name, terms_description.
-- Order By: invoice_id
SELECT i.invoice_id, i.invoice_total, v.vendor_name, t.terms_description
FROM invoices i
JOIN vendors v ON i.vendor_id = v.vendor_id
JOIN terms t ON i.terms_id = t.terms_id
ORDER BY i.invoice_id;



