# frozen_string_literal: true

module MarketPriceWatcher
  module Messages
    class << self
      def [](key)
        messages[key] || raise("Message #{key} not found")
      end

      def messages
        {
          goodbye: -> { "Надеюсь ты еще вернешься :)" },

          request_url: lambda {
            "Пришли мне URL адрес товара, цену которого хотите отслеживать, либо выберите одну из опций меню 👇🏼"
          },

          already_tracked_product: lambda do |id|
            "🔅 Товар с артикулом #{id} пропущен, так как добавлялся в список отслеживания ранее."
          end,

          show_product: lambda do |title, source_url, price, created_at, index|
            <<~TEXT
              #{index}. [#{title}](#{source_url})
              Текущая цена: #{MarketPriceWatcher::Utils::PriceFormatter.format(price)}
              Отслеживание начато: #{MarketPriceWatcher::Utils::DaysUntilToday.call(created_at)} дня(ей) назад
            TEXT
          end,

          empty_products: lambda do
            <<~TEXT
              Пока не отслеживается цена ни одного товара! Пришлите ссылку на товар, чтобы начать отслеживать его цену.
            TEXT
          end,

          add_product: lambda do
            <<~TEXT
              💻 На компьютере: пришлите ссылку на товар, цену которого хотите отслеживать.
              📱 На мобильном: кликните в браузере или приложении магазина "Поделиться", выберите Telegram и отправьте сообщение со ссылкой на товар боту.
              ℹ️ Каждый раз нажимать данную кнопку для добавления товара совсем необязательно, просто присылайте ссылку или делитесь ссылкой из приложения.
            TEXT
          end,

          start_tracking: lambda do |title, source_url, price|
            <<-TEXT.gsub(/^\s+/, "")
              🎬 Начат мониторинг цены и наличия
              [#{title}](#{source_url})
              Текущая цена: #{MarketPriceWatcher::Utils::PriceFormatter.format(price)}
            TEXT
          end,

          remove_from_tracking: lambda do |id|
            <<~TEXT
              ❗️ Товар с артикулом #{id} удалён из списка отслеживания!
            TEXT
          end,

          price_change: lambda do |title, source_url, new_price, prev_price, max_price, min_price, created_at|
            difference = new_price - prev_price
            percent_change = ((new_price - prev_price) * 1.0 / prev_price) * 100
            emoji = difference.positive? ? "↗️↗️↗️" : "↘️↘️↘️"
            up_or_down = difference.positive? ? "увеличилась" : "уменьшилась"
            format_price = ->(price) { MarketPriceWatcher::Utils::PriceFormatter.format(price) }

            <<-TEXT.gsub(/^\s+/, "")
              #{emoji} Цена #{up_or_down} на #{format_price.call(difference)} (#{'%.2f%%' % percent_change})
              [#{title}](#{source_url})

              Цена: #{format_price.call(new_price)} (было: #{format_price.call(prev_price)})

              Мин. цена: #{format_price.call(min_price)}
              Макс. цена: #{format_price.call(max_price)}
              Отслеживание начато: #{MarketPriceWatcher::Utils::DaysUntilToday.call(created_at)} дня(ей) назад
            TEXT
          end,

          help: lambda do
            <<~TEXT
              ❓ Бот платный?
              ➡️ Бот бесплатный для всех.

              ❓ В каких магазинах можно отслеживать наличие и цены?
              ➡️ На данный момент поддерживаются ozon и wildberris.

              ❓ Бот мониторит цены на товары только на конкретном сайте по отправленной ему ссылке?
              ➡️ Да, бот отслеживает цену на конкретном сайте. Чтобы бот следил за ценой на нескольких сайтах, необходимо прислать ссылку на каждый из них.

              ❓ Есть ли ограничение на количество отслеживаемых товаров?
              ➡️ Ограничения есть, но их сложно превысить, если вы используете бот в личных, а не коммерческих целях.

              ❓ Мне кажется, что бот неправильно определил цену или наличие товара.
              ➡️ Тут может быть несколько причин.
              1. В некоторых магазинах цена и наличие могут меняться в зависимости от выбранного города. Бот может увидеть цену в одном городе, а вы - в другом.
              2. Особо дефицитные товары могут исчезнуть быстрее, чем вы перешли по ссылке. Например, вы прочитали сообщение бота достаточно поздно. Аналогично с ценой - некоторые магазины делают скидку на час, а потом цена снова меняется. Так как бот узнает об изменении цены и наличия с некоторой задержкой, он мог не успеть оповестить вас о последнем изменении.
              3. Если вы авторизованы, магазин может показывать вам цены с персональной скидкой. Бот о вашей личной скидке ничего не знает и показывает базовую цену.
              4. Такие категории товаров, как одежда и обувь, не всегда отслеживаются по цвету и размеру. Переходя по ссылке может отказаться, что скидка есть только на конкретный размер или цвет.
              5. Даже бот может ошибаться.

              ❓ Как часто бот проверяет цены на сайтах?
              ➡️ В среднем раз в три часа. Бот не предназначен для отслеживания наличия дефицитных товаров с целью их покупки и дальнейшей перепродажи. Для таких задач рекомендуем использовать специализированные боты.
            TEXT
          end
        }
      end
    end
  end
end
