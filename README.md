<div align="center">
  <img width="800" alt="Expiry Tracker Logo/Banner" src="https://github.com/user-attachments/assets/f353c66a-201c-4b1a-8471-0d24f331741a" />
  
  # Expiry Tracker Mobile Application
  *A smart reminder-based solution to reduce waste and improve safety.*
</div>

---

## 📖 Introduction

People often forget product expiry dates. Expired food or medicine can cause severe health risks, and as a result, many products are wasted unnecessarily. The **Expiry Tracker Mobile Application** provides a smart, centralized solution to track expiration dates, receive timely reminder notifications, manage daily products easily, and ultimately reduce waste.

### ⚠️ Problem Statement
*   **Difficult to remember:** Manually keeping track of various product expiry dates is challenging.
*   **Inconvenient:** Manual checking of pantries and medicine cabinets is tedious.
*   **Health Risks:** Consuming expired products creates significant health hazards.
*   **Lack of Centralization:** No existing centralized tracking system for everyday items.

### 💡 Proposed Solution
The application acts as a personal inventory manager that will:
1.  Store product information securely.
2.  Monitor expiry dates automatically.
3.  Display products that are close to expiration on a user-friendly dashboard.
4.  Send automatic reminder notifications before products expire.

---

## ✨ Key Features
*   **User Authentication:** Secure sign-up and login functionalities.
*   **Product Management:** Easily Add, Edit, or Delete products.
*   **Expiry Notifications:** Automated warning notifications for expiring items.
*   **Product Categories:** Organize items effectively.
*   **Expiring Items Dashboard:** A quick-glance view of products nearing their end date.
*   **Cloud Data Storage:** Secure, real-time data syncing.

---

## 🛠️ Technology Stack

| Category | Technologies |
| :--- | :--- |
| **Frontend** | Flutter (Dart), HTML, CSS, JavaScript |
| **Backend** | Supabase (Authentication, Storage, API), Python |
| **Tools & Version Control** | VS Code, GitHub |

---

## ⚙️ Methodology & Workflow

The application workflow follows these straightforward steps:
1. User logs into the app.
2. Adds product details (name, category, expiry date).
3. Data is securely stored in Supabase.
4. The system tracks the expiry dates in the background.
5. Notifications are sent automatically when a product is nearing expiration.

<div align="center">
  <img width="700" alt="Methodology Flowchart" src="https://github.com/user-attachments/assets/5d911c48-3b71-4ca3-af24-eb5803b3ee09" />
</div>

---

## 🔄 SDLC Model: Agile

**Reason:** The application was developed incrementally. Features were added, tested, and improved through multiple iterations based on changing requirements and continuous feedback.

<div align="center">
  <img width="700" alt="Agile SDLC Diagram" src="https://github.com/user-attachments/assets/afe2fff9-3e7c-4499-958c-735b7a2eae98" />
</div>

---

## 📊 System Architecture & Diagrams

### Entity Relationship (ER) Diagram
The Entity Relationship diagram represents the database structure of the Expiry Tracker Mobile Application. It consists of two main entities: **User** and **Product**. 
*   The **User** entity stores information such as `UserID`, `email`, `password`, and `join date`. 
*   The **Product** entity stores product details like `ProductID`, `name`, and `expiry date`. 
*   A **one-to-many** relationship exists between User and Product (one user can add multiple products, but each product belongs to only one user). This ensures proper organization and efficient tracking of user-specific data.

<div align="center">
  <img width="700" alt="ER Diagram" src="https://github.com/user-attachments/assets/1a69942a-d1a0-434b-848b-cc68f25d6911" />
</div>

### Sequence Diagram
<div align="center">
  <img width="700" alt="Sequence Diagram" src="https://github.com/user-attachments/assets/d108e4a4-9ed7-47d8-87b5-f77e0c9db794" />
</div>

---

## 📱 App Screenshots

<table align="center">
  <tr>
    <td><img width="250" alt="App Screen 1" src="https://github.com/user-attachments/assets/825f9b27-716a-481c-9ff1-32b81d322558" /></td>
    <td><img width="250" alt="App Screen 2" src="https://github.com/user-attachments/assets/270b0b3d-cf52-4a8d-b786-8f833b1e573b" /></td>
    <td><img width="250" alt="App Screen 3" src="https://github.com/user-attachments/assets/2d7e0ce4-96c9-40ce-8f68-79203f19b374" /></td>
  </tr>
  <tr>
    <td><img width="250" alt="App Screen 4" src="https://github.com/user-attachments/assets/847a1e42-493b-4a5f-969f-94e8b1978cea" /></td>
    <td><img width="250" alt="App Screen 5" src="https://github.com/user-attachments/assets/8091d9aa-9a6b-4712-ac48-a31c13246cb1" /></td>
    <td><img width="250" alt="App Screen 6" src="https://github.com/user-attachments/assets/becc0bc0-7c36-433b-80b1-a90243b15f4e" /></td>
  </tr>
  <tr>
    <td><img width="250" alt="App Screen 7" src="https://github.com/user-attachments/assets/257228a0-ff8b-4478-8576-8372cd622acd" /></td>
    <td><img width="250" alt="App Screen 8" src="https://github.com/user-attachments/assets/ba428b23-bf53-444b-87ca-06300a62ad93" /></td>
    <td><img width="250" alt="App Screen 9" src="https://github.com/user-attachments/assets/46aba8c3-4e9b-4878-afa2-1c074402d279" /></td>
  </tr>
  <tr>
    <td><img width="250" alt="App Screen 10" src="https://github.com/user-attachments/assets/eb20052b-b919-48ad-a917-5310c7f6a542" /></td>
    <td><img width="250" alt="App Screen 11" src="https://github.com/user-attachments/assets/4dc042e2-5861-496e-8cb2-d5f848dd77fc" /></td>
    <td><img width="250" alt="Warning Notification" src="https://github.com/user-attachments/assets/a38070c6-d0a7-49ba-ad77-7be57d7451cd" /><br><p align="center"><b>Warning Notification</b></p></td>
  </tr>
</table>

 Thank you.
