#--Most ordered items
SELECT menu_items.item_name, menu_items.category, COUNT(DISTINCT(order_details.order_details_id)) AS most_ordered_items
FROM menu_items
JOIN order_details
ON menu_items.menu_item_id = order_details.item_id
WHERE order_details.item_id IS NOT NULL
GROUP BY item_name, category
ORDER BY most_ordered_items DESC
LIMIT 5;

#Least ordered items
SELECT menu_items.item_name, menu_items.category, COUNT(DISTINCT(order_details.order_details_id)) AS least_ordered_items
FROM menu_items
JOIN order_details
ON menu_items.menu_item_id = order_details.item_id
WHERE order_details.item_id IS NOT NULL
GROUP BY item_name, category
ORDER BY least_ordered_items ASC
LIMIT 5;



#Finding the highest spend orders
WITH RankedOrders AS (
SELECT order_id, total_amount_spent_per_order, NTILE(100) OVER(ORDER BY total_amount_spent_per_order DESC) AS PercentileRanking
FROM (
SELECT order_details.order_id, SUM(menu_items.price) AS total_amount_spent_per_order
FROM order_details
JOIN menu_items
ON order_details.item_id = menu_items.menu_item_id
GROUP BY order_details.order_id
)
AS OrderTotals
)

SELECT RankedOrders.order_id, RankedOrders.total_amount_spent_per_order, menu_items.item_name
FROM RankedOrders
JOIN order_details
ON RankedOrders.order_id = order_details.order_id
JOIN menu_items
ON order_details.item_id = menu_items.menu_item_id
WHERE RankedOrders.PercentileRanking = 1
ORDER BY total_amount_spent_per_order DESC;


# Number of orders gotten per hour
SELECT COUNT(order_id) AS total_orders, HOUR(order_time) AS hour_of_day
FROM order_details
GROUP BY HOUR(order_time)


