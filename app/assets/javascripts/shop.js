var MapYa = function () { ymaps.ready(init) };

function init() {

    var myMap = new ymaps.Map("map", {
            center: [$('#map').data('lat'), $('#map').data('lon')],
            zoom: 16
        }, {
            searchControlProvider: 'yandex#search'
        }),

    // Создаем геообъект с типом геометрии "Точка".
        myGeoObject = new ymaps.GeoObject({
            // Описание геометрии.
            geometry: {
                type: "Point",
                coordinates: [$('#map').data('lat'), $('#map').data('lon')]
            },
            // Свойства.
            properties: {
                // Контент метки.
                hintContent: 'Арыш Мае'
            }
        }, {
            // Опции.
            // Иконка метки будет растягиваться под размер ее содержимого.
           preset: 'islands#redDotIcon'
            // Метку можно перемещать.

        });

        myMap.geoObjects
            .add(myGeoObject)

};


var date_pic = function () { $('.datepicker').datetimepicker(); };

document.addEventListener('turbolinks:load', function () {
        date_pic();
});

document.addEventListener('turbolinks:load', function () {
  MapYa();
});
