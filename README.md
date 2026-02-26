🏨 Hotel Management System - Database Design

Mandatory Assignment 1: Databases for Developers Group: Asger Bergøe, Magnus, Sophus, Joel
📌 Project Overview

This project implements a relational database for a boutique hotel system. It handles everything from seasonal pricing logic (Spring, Summer, Autumn, Winter) and guest reservations to automated housekeeping tasks and billing for minibar/extra services.
🛠 Tech Stack

    DBMS: MySQL 8.0+

    Tooling: DataGrip / MySQL Workbench

    Design: Miro (ERD)

🏗 Database Architecture

The database consists of 13 tables designed to ensure 3rd Normal Form (3NF) and data integrity.

    Junction Tables: RESERVATION_GUEST and ROOM_CLEANING_ASSIGNMENT manage Many-to-Many relationships.

    Automation: Stored procedures and triggers handle the "heavy lifting" of state changes and financial calculations.

    Optimization: Strategic indexing on email and reference_no for high-performance querying.

🚀 Installation & Setup (DataGrip)

Follow these steps to deploy the database with full operational capabilities:
1. Create the Schema

Open and execute 01_schema.sql.

    This builds the structure, defines Primary/Foreign Keys, and sets up CHECK constraints (e.g., ensuring check_out is after check_in).

2. Populate Test Data

Execute 02_test_data.sql.

    This loads "realistic" data including:

        16 seasonal rates across 4 room types (Loft, XL Loft, Presidential, Love Suite).

        Minibar inventory prices.

        Sample guests and active reservations.

3. Initialize Logic & Automation

Execute 03_logic.sql.

    This installs the "Brain" of the system:

        Trigger: tr_AfterCheckout (Automatically flags rooms as 'Dirty' and creates a cleaning task upon checkout).

        Procedure: sp_CalculateFinalBill (Calculates stay cost + extra services).

        View: vw_HousekeepingList (A simplified dashboard for staff).

📈 Key Features Implemented
Feature	Implementation	Purpose
Integrity	Foreign Keys & ENUMs	Prevents orphan data and invalid statuses.
Logic	Stored Function	fn_GetRoomRate fetches DKK prices based on season.
Automation	Triggers	Seamlessly updates room status without manual input.
Performance	Indexes	Optimized search for guest lookups and reservation numbers.
Reporting	Views	Aggregates room and task data for housekeeping staff.
📂 Repository Structure

    /01_schema.sql - Data Definition Language (DDL)

    /02_test_data.sql - Realistic seed data

    /03_logic.sql - Procedures, Triggers, Views, and Indexes

    /ERD/ - Screenshots of Conceptual, Logical, and Physical models

If you have any questions or need further assistance, please feel free to reach out to the team. Happy querying!