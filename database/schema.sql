-- testniyech.uz database schema
-- PostgreSQL

CREATE SCHEMA IF NOT EXISTS testniyech;
SET search_path TO testniyech, public;

CREATE TABLE IF NOT EXISTS testniyech.site_announcements (
    id SMALLINT PRIMARY KEY CHECK (id = 1),
    message TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 1. Admins
CREATE TABLE IF NOT EXISTS testniyech.admins (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(150),
    role VARCHAR(50) DEFAULT 'admin',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Classes (Sinflar: 1-A, 1-B, 5-A, 11-B ...)
CREATE TABLE IF NOT EXISTS testniyech.classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- Masalan '5-A'
    grade_level INTEGER NOT NULL,     -- Masalan 5
    letter VARCHAR(10) NOT NULL,      -- Masalan 'A'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Students (O'quvchilar)
-- Bir xil ism, familiya va otasining ismi bo'lishi mumkin.
CREATE TABLE IF NOT EXISTS testniyech.students (
    id SERIAL PRIMARY KEY,
    student_code VARCHAR(50) NOT NULL UNIQUE, -- 'TN-10023'
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female')),
    class_id INTEGER REFERENCES testniyech.classes(id) ON DELETE SET NULL,
    pin_code VARCHAR(10) NOT NULL, -- 4 xonali PIN kod
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE testniyech.students
    ADD COLUMN IF NOT EXISTS gender VARCHAR(10) CHECK (gender IN ('male', 'female'));

-- 4. Student Classes history (Sinf o'zgarishlari tarixi)
CREATE TABLE IF NOT EXISTS testniyech.student_classes (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES testniyech.students(id) ON DELETE CASCADE,
    class_id INTEGER REFERENCES testniyech.classes(id) ON DELETE SET NULL,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- 5. Tests
CREATE TABLE IF NOT EXISTS testniyech.tests (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    description TEXT,
    duration_minutes INTEGER NOT NULL DEFAULT 45,
    is_active BOOLEAN DEFAULT TRUE,
    is_all_classes BOOLEAN DEFAULT FALSE, -- agar true bo'lsa barcha sinflarga
    created_by INTEGER REFERENCES testniyech.admins(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Test Assignments (Testni sinflarga biriktirish)
CREATE TABLE IF NOT EXISTS testniyech.test_assignments (
    id SERIAL PRIMARY KEY,
    test_id INTEGER NOT NULL REFERENCES testniyech.tests(id) ON DELETE CASCADE,
    class_id INTEGER NOT NULL REFERENCES testniyech.classes(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (test_id, class_id)
);

-- 7. Questions
-- question_type: 'multiple_choice' yoki 'open_text'
CREATE TABLE IF NOT EXISTS testniyech.questions (
    id SERIAL PRIMARY KEY,
    test_id INTEGER NOT NULL REFERENCES testniyech.tests(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    image_url TEXT,
    question_type VARCHAR(50) NOT NULL CHECK (question_type IN ('multiple_choice', 'open_text')),
    points NUMERIC(6, 2) NOT NULL DEFAULT 1.00,
    order_num INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Answer Options (Faqat multiple_choice savollar uchun)
CREATE TABLE IF NOT EXISTS testniyech.answer_options (
    id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES testniyech.questions(id) ON DELETE CASCADE,
    option_label VARCHAR(10) NOT NULL, -- 'A', 'B', 'C', 'D'
    option_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    order_num INTEGER NOT NULL DEFAULT 1
);

-- 9. Test Attempts (O'quvchi test ishlash sessiyasi)
-- status: 'in_progress', 'submitted', 'grading', 'graded'
CREATE TABLE IF NOT EXISTS testniyech.test_attempts (
    id SERIAL PRIMARY KEY,
    test_id INTEGER NOT NULL REFERENCES testniyech.tests(id) ON DELETE CASCADE,
    student_id INTEGER NOT NULL REFERENCES testniyech.students(id) ON DELETE CASCADE,
    class_name VARCHAR(50), -- topshirgan vaqtdagi sinfi (tarix saqlash uchun)
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(50) NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'submitted', 'grading', 'graded')),
    score_awarded NUMERIC(6, 2) DEFAULT 0.00,
    max_score NUMERIC(6, 2) DEFAULT 0.00,
    percentage NUMERIC(6, 2) DEFAULT 0.00,
    correct_count INTEGER DEFAULT 0,
    incorrect_count INTEGER DEFAULT 0,
    pending_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 10. Student Answers (O'quvchi javoblari)
CREATE TABLE IF NOT EXISTS testniyech.student_answers (
    id SERIAL PRIMARY KEY,
    attempt_id INTEGER NOT NULL REFERENCES testniyech.test_attempts(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES testniyech.questions(id) ON DELETE CASCADE,
    selected_option_id INTEGER REFERENCES testniyech.answer_options(id) ON DELETE SET NULL,
    open_answer_text TEXT,
    is_correct BOOLEAN,
    score_awarded NUMERIC(6, 2) DEFAULT 0.00,
    max_score NUMERIC(6, 2) DEFAULT 1.00,
    admin_feedback TEXT,
    graded_by INTEGER REFERENCES testniyech.admins(id) ON DELETE SET NULL,
    graded_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (attempt_id, question_id)
);

-- 11. Results (Natijalar xulosasi)
CREATE TABLE IF NOT EXISTS testniyech.results (
    id SERIAL PRIMARY KEY,
    attempt_id INTEGER NOT NULL UNIQUE REFERENCES testniyech.test_attempts(id) ON DELETE CASCADE,
    student_id INTEGER NOT NULL REFERENCES testniyech.students(id) ON DELETE CASCADE,
    test_id INTEGER NOT NULL REFERENCES testniyech.tests(id) ON DELETE CASCADE,
    student_full_name VARCHAR(255) NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    test_title VARCHAR(255) NOT NULL,
    total_score NUMERIC(6, 2) NOT NULL DEFAULT 0.00,
    max_score NUMERIC(6, 2) NOT NULL DEFAULT 0.00,
    percentage NUMERIC(6, 2) NOT NULL DEFAULT 0.00,
    correct_count INTEGER DEFAULT 0,
    incorrect_count INTEGER DEFAULT 0,
    pending_count INTEGER DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'grading', 'graded')),
    completed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indekslar tezkor ishlash uchun
CREATE INDEX IF NOT EXISTS idx_students_class_id ON testniyech.students(class_id);
CREATE INDEX IF NOT EXISTS idx_students_names ON testniyech.students(last_name, first_name, middle_name);
CREATE INDEX IF NOT EXISTS idx_students_code ON testniyech.students(student_code);
CREATE INDEX IF NOT EXISTS idx_questions_test_id ON testniyech.questions(test_id);
CREATE INDEX IF NOT EXISTS idx_options_question_id ON testniyech.answer_options(question_id);
CREATE INDEX IF NOT EXISTS idx_attempts_student_id ON testniyech.test_attempts(student_id);
CREATE INDEX IF NOT EXISTS idx_attempts_test_id ON testniyech.test_attempts(test_id);
CREATE INDEX IF NOT EXISTS idx_answers_attempt_id ON testniyech.student_answers(attempt_id);
CREATE INDEX IF NOT EXISTS idx_answers_graded ON testniyech.student_answers(graded_at);
CREATE INDEX IF NOT EXISTS idx_results_student ON testniyech.results(student_id);
CREATE INDEX IF NOT EXISTS idx_results_test ON testniyech.results(test_id);
