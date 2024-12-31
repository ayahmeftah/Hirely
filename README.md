# Hirely

## GitHub Link
[Hirely Public Repository](https://github.com/ayahmeftah/Hirely)

## Group Members

| Name            | Student ID  |
|-----------------|-------------|
| Mayyar Sakhnini | 202200225   |
| Khadija Abdulla | 202201013   |
| Manar Alsetrawi | 202200412   |
| Areej Yusuf     | 202100673   |
| Ayah Meftah     | 202201592   |

## Main Features

|**Category**                          | **Feature**                          | **Developer**       | **Tester**          |
|--------------------------------------|--------------------------------------|---------------------|---------------------|
|Job Discovery & Career Recommendations| Job Details & Recommendations        | Ayah Meftah         | Khadija Abdulla     |
|                                      | Job Searching & Listing              | Ayah Meftah         | Manar Alsetrawi     |
|Job Application                       | Job Application                      | Khadija Abdulla     | Ayah Meftah         |
|                                      | Application Status Tracker           | Khadija Abdulla     | Manar Alsetrawi     |
|CV Creation & Career Resources        | CV Builder                           | Areej Yusuf         | Mayyar Sakhnini     |
|                                      | Career Resources Hub                 | Areej Yusuf         | Mayyar Sakhnini     |
| User Authentication & Preferences    | User Authentication                  | Mayyar Sakhnini     | Areej Yusuf         |
|                                      | User Profiles and Settings           | Mayyar Sakhnini     | Areej Yusuf         |
|Admin Controls & Platform Management  | Content Moderation Tool              | Manar Alsetrawi     | Areej Yusuf         |
|                                      | Job Posting                          | Manar Alsetrawi     | Ayah Meftah         |
|                                      | Application Review & Scheduling      | Manar Alsetrawi     | Khadija Abdulla     |
|                                      | Resource Management                  | Areej Yusuf         | Manar Alsetrawi     |

## Extra Features 

| Name            | Extra Feature                                      |
|-----------------|----------------------------------------------------|
| Mayyar Sakhnini | Firebase(Authintication & Firestore) + Cloudinary  |
| Khadija Abdulla | Firebase(Firestore) + Cloudinary                   |
| Manar Alsetrawi | Firebase(Firestore) + Cloudinary                   |
| Areej Yusuf     | Firebase(Firestore) + Cloudinary                   |
| Ayah Meftah     | Firebase(Firestore) + Cloudinary                   |

## Design Changes

|**Category**                                  | **Feature**                          | **Developer**       | **Changes**         |
|----------------------------------------------|--------------------------------------|---------------------|---------------------|
|Job Discovery & Career Recommendations        | Job Details & Recommendations        | Ayah Meftah         |   Adjustments in the height were made to the buttons on top in the Applicant Dashboard. Their heights are now all equal unlike the prototype. This is because we faced some problems with the constraints.|
|                                              | Job Searching & Listing              | Ayah Meftah         |  The search bar is now not displayed on the results page. The user can return to the search page to search again.|
|Job Application                               | Job Application                      | Khadija Abdulla     |  1- The upload Cover Letter button was removed from the Job Application screen. |
|                                              | Application Status Tracker           | Khadija Abdulla     |   1- The location of the status bar was changed and went to the bottom of the cell rather than the centre-right in the Application Status Update screen. 2- The button for the interview details was replaced with a tab bar button item. 3- Adjustments were made to the Interview Details screen to look similar to the previous screen.   |
|CV Creation & Career Resources                | CV Builder                           | Areej Yusuf         |    No changes  |
|                                              | Career Resources Hub                 | Areej Yusuf         |    No changes|
| User Authentication & Preferences            | User Authentication                  | Mayyar Sakhnini     |      Email Verification Step Removed.    |
|                                              | User Profiles and Settings           | Mayyar Sakhnini     |    1-Experience section is removed from the Skills and Experience option. 2- Bookmarks are removed from the applicant profile. 3-The resume option in the applicant profile was changed to display only the latest generated CV for the applicant instead of showing all the generated CVs. 4- Employer profile is removed.|
|Admin Controls & Platform Management          | Content Moderation Tool              | Manar Alsetrawi     |     1- In the admin feature, the suspended and reactivate account is removed due to complexity, so the actions menu is removed  and replaced with a delete account button.     |
|                                              | Job Posting                          | Manar Alsetrawi     |   1-Skills search in employer changed to list as table view. 2- Job details for the employer removed buttons at the bottom  for editing, deleting and hiding the job because they are already displayed when the employer views the job so it will be redundant code. 2- Edit post action is removed from the admin since the employer will review the flagged post and is responsible for making the changes. 3- Remove the flag date field from the flag post screen and instead the current time stamp will be automatically saved|
|                                              | Resource Management                  | Areej Yusuf         |   No changes  |

## Libraries, Packages, External Code Implementations

- Firebase Package: https://github.com/firebase/firebase-ios-sdk
- Cloudinary: https://github.com/cloudinary/cloudinary_ios
- This is a playlist created by Manar (Watched by all members): https://youtube.com/playlist?list=PLz-abeZuamzCg2vbGClmHaDzJGf3rKIdt&si=GlJ2uihYuEFHsZ0y

## Setup

To set up this project, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/hirely.git
   ```
2. Navigate to the project directory.
3. Open project.

## Simulators Used for Testing

- iPhone 15 Pro
  
## Admin Login Credentials

- **Email:** admin@hirely.com
- **Password:** admin@123

## Applicant Login Credentials

- **Email:** khalidali@gmail.com
- **Password:** khalid@123

## Employer Login Credentials

- **Email:** miaclark@gmail.com
- **Password:** mia@12345
