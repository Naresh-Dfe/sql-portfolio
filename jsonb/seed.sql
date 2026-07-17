insert into events (user_id, event_type, created_at, payload) values
(1, 'signup',   '2024-03-01 09:12', '{"plan": "free", "referrer": "google", "device": {"os": "android", "app_version": "2.1.0"}}'),
(1, 'purchase', '2024-03-04 14:40', '{"amount": 499, "currency": "INR", "items": ["ebook"], "coupon": "WELCOME10"}'),
(2, 'signup',   '2024-03-05 08:03', '{"plan": "free", "referrer": "twitter", "device": {"os": "ios", "app_version": "2.1.0"}}'),
(2, 'purchase', '2024-03-06 19:22', '{"amount": 1299, "currency": "INR", "items": ["ebook", "course"]}'),
(3, 'signup',   '2024-03-07 11:47', '{"plan": "pro", "referrer": "google", "device": {"os": "android", "app_version": "2.0.5"}}'),
(3, 'purchase', '2024-03-09 16:15', '{"amount": 2999, "currency": "INR", "items": ["course"], "coupon": "SPRING"}'),
(3, 'purchase', '2024-03-15 10:30', '{"amount": 799, "currency": "INR", "items": ["ebook"]}'),
(4, 'signup',   '2024-03-10 13:05', '{"plan": "free", "referrer": "direct", "device": {"os": "ios", "app_version": "2.1.1"}}'),
(4, 'purchase', '2024-03-12 20:18', '{"amount": 1299, "currency": "INR", "items": ["course"], "coupon": "SPRING"}'),
(5, 'signup',   '2024-03-11 07:55', '{"plan": "pro", "referrer": "twitter", "device": {"os": "android", "app_version": "2.1.1"}}');
