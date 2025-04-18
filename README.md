# Student-Management-System-SMS-

📚 Student Management System (SMS) — Bash Scripting Project

Overview
This project is a command-line Student Management System (SMS) developed using Bash scripting on a Linux-based OS (tested on Ubuntu). It enables a single teacher to manage up to 20 students efficiently through a simple terminal interface. The system includes functionalities for adding, updating, deleting student records, as well as calculating grades and CGPA, saving and loading data from a file for persistence, and student self-service access. This project was developed as a mini semester project for CS2006 — Operating Systems, Spring 2025 under the supervision of Instructor: Hassan Ahmed.

✨ Features
🔹 Teacher Account
Login using teacher credentials.

Add Students: Add up to 20 students (Roll No, Name, Total Marks, etc.).

Delete Student: Remove a student record based on Roll No.

Update Student Information: Modify student marks and other details.

Assign Marks: Allocate marks to each student.

Calculate Grades: Auto-generate grades using FAST’s grading criteria.

Calculate CGPA: Calculate CGPA for each student based on grades and marks.

Generate Reports:

List of passed students (CGPA above threshold).

List of failed students (CGPA below threshold).

Students sorted by CGPA (ascending/descending order).

Save and Load Data: Save all student records to a text file and retrieve them later for persistence.

🔹 Student Account
Login using individual student credentials.

View Grades: Display grades assigned for different subjects.

View CGPA: Display cumulative GPA based on performance.

🛠️ System Requirements
Linux OS (e.g., Ubuntu 20.04 or later)

Bash Shell v4.0 or later

Nano or Vim text editor (for coding)

🚀 Project Workflow
Teacher
Login to the system.

Select options:

Add new students.

Assign and update marks.

Calculate grades and CGPA.

View lists of passed/failed students.

Save data persistently in a text file.

Student
Login to view personal academic records.

Check assigned grades.

View CGPA based on cumulative marks.

SMS/
├── sms.sh               # Main Bash script for the Student Management System
├── students.txt         # (Generated) File to store all student records
├── README.md            # (This file) Detailed description of the project

⚡ Sample Functionalities
✅ Add new student records.

✅ Update marks and re-calculate CGPA.

✅ Sort students based on performance.

✅ View list of passed and failed students.

✅ Students login to check grades and CGPA.

📌 Important Notes
Single Teacher system management (no multi-teacher support).

Maximum 20 students supported per session.

Persistent storage through plain text files (no databases involved).

Built strictly using Bash scripting, without external libraries or advanced tools.

💬 Final Words
This project demonstrates the power of Bash scripting for real-world administrative tasks like academic record management. It emphasizes core concepts of file handling, data structures, and command-line interaction, aligning perfectly with the objectives of the Operating Systems course.
