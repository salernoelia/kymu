# Kymu

![Kymu Showcase](/public/promotion/kymu-showcase.jpg)

**Kymu** is a platform designed for hybrid pediatric neuromuscular rehabilitation. Developed as a **Bachelor's Thesis project** at the **Zurich University of the Arts**, Kymu aims to bridge the gap between traditional in-clinic therapy and effective home-based exercises for children with neuromuscular conditions.

**Status:** Work in Progress (Thesis Project - June 2025)

## Related Repositories

- [Exhibition Application with focus on body tracking in front of a TV (Kymu Exhibition)](https://github.com/salernoelia/kymu-exhibition)
- [Unity VR/MR Prototype (Kymu VR)](https://github.com/salernoelia/kymu-vr)

## Project Overview

Kymu addresses key challenges in pediatric neuromuscular physiotherapy, such as:

- The logistical and emotional burden of frequent clinic visits for both patients and caregivers.
- Maintaining patient **motivation** and adherence to repetitive home exercise plans.
- Providing therapists with **objective, quantitative data** on patient performance and wellbeing outside the clinic.

Our solution is a hybrid platform featuring a web-based application for therapists and an accessible interface for patients and caregivers:

- **For Therapists:** A comprehensive web platform allows therapists to manage patient profiles, create and customize personalized training plans (called "Units"), track patient progress through data visualization, and gain insights into exercise performance and reported wellbeing. The editor supports a flexible, data-driven approach to therapy planning.
- **For Patients & Caregivers:** An accessible interface (currently explored for TV/Screen-based and potentially VR interactions) guides patients through prescribed exercises at home. The system aims to make therapy more engaging and provides clear instructions and feedback.
- **Data Integration:** The platform collects data on exercise completion, duration, repetitions, range of motion (ROM - particularly explored through pose tracking), and patient-reported pain/wellbeing, providing therapists with valuable information for data-driven adjustments and communication.

## Key Features

- **Patient Management:** Organize patient profiles and access their therapy history.
- **Customizable Training Units:** Build personalized exercise plans using a flexible editor (Kanban-style workflow explored).
- **Exercise Modalities:** Support for various exercise types (screen-based, video instruction, and VR/AR/pose-tracking based exercises explored).
- **Performance Tracking:** Collect quantitative data on exercise execution (e.g., ROM, duration, repetitions).
- **Wellbeing Monitoring:** Capture qualitative and quantitative patient feedback (e.g., pain levels).
- **Data Visualization:** Present patient progress and performance data clearly for therapists.
- **Hybrid Approach:** Complementary to in-clinic sessions, enabling remote therapy management and execution.

As the thesis explores many features, only some of theme were prototyped out and are sometimes split into different repositories, mentioned in the 'Related Repositories' section.

## Technology Stack

- **Frontend:** Nuxt 3 (Vue 3)
- **Backend & Database:** Supabase (PostgreSQL, Authentication, Storage)
- **Pose Tracking:** Google MediaPipe
- **VR/3D Development** Unity
- **Mobile Packaging:** Capacitor (for potential mobile interfaces, currently out of scope)
- **Other Libraries:** D3.js (Data Visualization), Tone.js (Audio Feedback)

## Design & Research Approach

The project is rooted in a **Human-Centered Design** methodology, emphasizing the needs and contexts of pediatric patients with NMDs, their caregivers, and therapists. Our iterative process involved:

- Extensive literature review on NMDs, HCD, Telerehabilitation, and VR in therapy.
- Expert interviews with physiotherapists and researchers in the field.
- User testing with potential patients and their families.
- Prioritization of features based on user needs and technical feasibility.
- Focusing on **Motivation, Data-Driven Personalization, and Accessibility** (derived from the thesis hypotheses).

## Authors

- Elia Salerno
- Stepan Vedunov

_(This project is part of a Bachelor's Thesis at the Zurich University of the Arts.)_
