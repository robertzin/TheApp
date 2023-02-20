# TheApp

![TheApp](https://user-images.githubusercontent.com/60647627/220181205-904530f9-b60c-4045-aaf8-1e4969f8a327.jpg)

Новостное приложение для проверки знаний.

Логика:
- Экран-заставка
- Авторизация (log in, sign up, password reset)
- TabBar:
    - Новости
    - Карта
    - Избранное
    - Профиль
    
Использованный стек технологий:
- CollectionView
- SnapKit, Kingfisher
- Networking, API (https://newsapi.org/)
- CoreData, FetchResultController
- MapKit

Расхождение с макетом:
- кнопка "Регистрация" на экране "Регистрация" ведет на к таб бару сразу, а на экран "Вход" для более понятного пользовательского опыта
- установлена иная заставка
