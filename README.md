# Advanced SQL Concurrency: Deadlocks and MVCC

This repository contains a SQL script (`Deadlock_MVCC_Demo.sql`) that demonstrates advanced database concurrency control concepts. The script provides a hands-on simulation of two critical scenarios: **transactional deadlocks** and **Multiversion Concurrency Control (MVCC)**.

Using a `StudentEnrollments` table, this project shows how deadlocks occur, how databases automatically resolve them, and how MVCC allows for non-blocking reads to improve performance in high-concurrency environments.

---

## Key Concepts Covered

* **Deadlock**: A situation where two or more transactions are in a circular wait, each waiting for a resource that the other holds. Databases must detect this and abort one transaction to resolve the cycle.
* **Multiversion Concurrency Control (MVCC)**: A technique where the database maintains multiple versions of a row. When a transaction starts, it is given a "snapshot" of the data. This allows readers to access a consistent version of the data without blocking or being blocked by writers.
* **Transactional Isolation**: The degree to which transactions are isolated from one another. MVCC is a key mechanism for implementing isolation levels like `READ COMMITTED` and `REPEATABLE READ`.
* **Blocking vs. Non-blocking Operations**: The script contrasts traditional locking mechanisms (which cause blocking) with MVCC (which allows non-blocking reads).

---

## Prerequisites

To run this script, you will need a running instance of a relational database system that supports both deadlock detection and MVCC, such as:
* MySQL (using the InnoDB storage engine)
* PostgreSQL
* Oracle

---

## How to Use

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/adbms_practice3_unit1.git](https://github.com/your-username/adbms_practice3_unit1.git)
    ```
2.  **Connect to your database:** Use your preferred SQL client to connect to your database server.
3.  **Run the script:** Open and execute the `Deadlock_MVCC_Demo.sql` file.

**⭐ Important Simulation Note:**
To properly observe the **deadlock** and **blocking** effects, you **must** run the commands for "Session 1" and "Session 2" in **two separate, simultaneous database connections** (for example, two different query tabs in your SQL client). The script is heavily commented to guide you on which command to run in which session and in what order.

---

## Script Breakdown

The SQL script is divided into three main parts:

* **Part A: Simulating a Deadlock**
    * Simulates two transactions (`Session 1` and `Session 2`) that acquire locks on two different rows.
    * Each transaction then attempts to acquire a lock on the row held by the other, but in the reverse order, creating a circular wait.
    * **Demonstrates**: How a deadlock is triggered and how the database automatically detects it and aborts one of the transactions to resolve the issue.

* **Part B: Applying MVCC for Concurrent Reads/Writes**
    * Simulates a "Reader" (`User A`) starting a transaction and reading a row.
    * While the reader's transaction is still open, a "Writer" (`User B`) updates and commits a change to the very same row.
    * **Demonstrates**: The core benefit of MVCC. The reader is **not blocked** and continues to see the original, consistent "snapshot" of the data from when its transaction began.

* **Part C: Comparing Locking vs. MVCC**
    * **Scenario 1 (Locking)**: Uses `SELECT FOR UPDATE` to show how a writer can explicitly lock a row, causing any other session trying to read-lock the same row to be **blocked** until the first transaction finishes.
    * **Scenario 2 (MVCC)**: Repeats the non-blocking read scenario from Part B to directly contrast it with the locking behavior.
    * **Demonstrates**: The performance and concurrency difference between traditional locking and modern MVCC-based systems.

---

## Expected Output

* **Part A**: The script will cause a deadlock error in one of the sessions (e.g., `ERROR 1213: Deadlock found...`). The final `SELECT` will show that only the transaction that was *not* aborted was successfully committed.
* **Part B & C**: The script comments will guide you to observe where one session would be blocked (in the locking scenario) versus where it would read old data without waiting (in the MVCC scenario). The final state of the table will be consistent.
