# NewsReader

NewsReader is RSS 2.0 Reader for iOS. Writed on Swift and Objective-C. Next description will be on Russian. Sorry, but my english skills are bad.

## Описание

Данный проект написан в рамках курсов по разработке под iOS от EPAM Systems. Основная часть проекта написана на языке Swift 2.1. Проект включает в себя следующий функционал:

- Парсинг xml-документов соответствующих формату RSS 2.0.
- Сохранение данных в Core Data.
- Вывод данных в удобочитаемом виде.
- Lazy loading для изображений в списке новостей.
- Web View для развернутой новости, а также некоторых других элементов.
- Возможность рисования на изображении новости.
- И другое...

Небольшая часть проекта, в частности "Рисование" написана на Objective-C. Это необходимо для демонстрации возможности и умения работы в одном проекте с двумя языками: Swift и Objective-C.

Проект находится в стадии разработки.

## Установка

Склонируйте этот репозиторий используя следующую команду:

    $ git clone https://github.com/Karetski/NewsReader.git

Перейдите в каталог с проектом:

    $ cd NewsReader

Откройте при помощи XCode:

    $ open NewsReader.xcodeproj

## License

NewsReader is released under the [MIT License](http://www.opensource.org/licenses/MIT).
