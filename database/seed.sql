-- testniyech.uz seed data
SET search_path TO testniyech, public;

-- 1. Admin hisobi
INSERT INTO testniyech.admins (username, password_hash, full_name, email, role)
VALUES (
    'admin',
    '$2a$10$waX35VtKfYySshr3Vpjuce.WDHd2IQsWVmi29uBQjPaTBJvMXxpOK',
    'Bosh Administrator',
    'admin@testniyech.uz',
    'admin'
) ON CONFLICT (username) DO NOTHING;
