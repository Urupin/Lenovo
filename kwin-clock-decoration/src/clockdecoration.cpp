#include "clockdecoration.h"
#include "clockbutton.h"
#include "clockdecoration_logging.h"

#include <KDecoration3/kdecoration3/decoratedwindow.h>
#include <KDecoration3/DecorationButton>
#include <KDecoration3/DecorationSettings>
#include <KDecoration3/DecorationShadow>
#include <KLocalizedString>

#include <QDateTime>
#include <QFontMetrics>
#include <QPainter>

ClockDecoration::ClockDecoration(QObject *parent, const QVariantList &args)
    : KDecoration3::Decoration(parent, args)
{
}

bool ClockDecoration::init()
{
    // Set border sizes before painting starts
    setBorders(QMarginsF(6, m_titleHeight + 4, 6, 6));
    setResizeOnlyBorders(QMarginsF(6, m_titleHeight + 4, 6, 6));

    createButtons();

    auto w = window();
    if (w) {
        connect(w, &KDecoration3::DecoratedWindow::sizeChanged, this, [this] {
            layoutButtons();
            update();
        });
        connect(w, &KDecoration3::DecoratedWindow::activeChanged, this, [this](bool) { update(); });
        connect(w, &KDecoration3::DecoratedWindow::captionChanged, this, [this](const QString &) { update(); });
    }

    layoutButtons();

    return true;
}

void ClockDecoration::createButtons()
{
    using namespace KDecoration3;

    // Order: Close at the outer edge, then Maximize, then Minimize.
    const QList<DecorationButtonType> order = {
        DecorationButtonType::Close,
        DecorationButtonType::Maximize,
        DecorationButtonType::Minimize,
    };

    m_buttons.clear();
    for (auto type : order) {
        auto btn = new ClockButton(type, this, this);
        btn->setSize(m_buttonSize);
        m_buttons.append(btn);
    }
}

void ClockDecoration::layoutButtons()
{
    const auto area = QRectF(QPointF(0, 0), QSizeF(size()));
    const int right = int(area.right()) - m_spacing;
    int x = right - m_buttonSize;
    const int y = (m_titleHeight - m_buttonSize) / 2;

    for (auto &btn : m_buttons) {
        if (!btn) {
            continue;
        }
        btn->setGeometry(QRectF(x, y, m_buttonSize, m_buttonSize));
        x -= (m_buttonSize + m_spacing);
    }
}

QString ClockDecoration::currentTimeString() const
{
    return QDateTime::currentDateTime().toString(QStringLiteral("ddd dd.MM.yyyy HH:mm"));
}

QColor ClockDecoration::backgroundColor() const
{
    const bool active = window() && window()->isActive();
    return active ? QColor("#2d2f3a") : QColor("#31343f");
}

QColor ClockDecoration::foregroundColor() const
{
    const bool active = window() && window()->isActive();
    return active ? QColor("#f5f5f5") : QColor("#c1c7d0");
}

void ClockDecoration::paint(QPainter *painter, const QRectF &)
{
    const QRectF fullRect(QPointF(0, 0), QSizeF(size()));
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, true);

    // Background
    painter->setBrush(backgroundColor());
    painter->setPen(Qt::NoPen);
    painter->drawRoundedRect(fullRect.adjusted(0.5, 0.5, -0.5, -0.5), 6, 6);

    // Caption and time
    const QString title = window() ? window()->caption() : QString();
    const QString timeText = currentTimeString();

    QFont titleFont = settings()->font();
    titleFont.setBold(true);
    painter->setFont(titleFont);
    painter->setPen(foregroundColor());

    const int leftPadding = 12;
    const int rightPadding = m_buttonSize * m_buttons.size() + (m_spacing * (m_buttons.size() + 1));
    const QRectF textRect(leftPadding,
                          0,
                          fullRect.width() - leftPadding - rightPadding,
                          m_titleHeight);

    QFontMetrics fmTitle(titleFont);
    painter->drawText(textRect, Qt::AlignVCenter | Qt::AlignLeft, fmTitle.elidedText(title, Qt::ElideRight, int(textRect.width() / 2)));

    QFont timeFont = settings()->font();
    timeFont.setBold(true);
    painter->setFont(timeFont);
    QFontMetrics fmTime(timeFont);
    const QString timeElided = fmTime.elidedText(timeText, Qt::ElideRight, int(textRect.width() / 2));
    painter->drawText(textRect, Qt::AlignVCenter | Qt::AlignRight, timeElided);

    // Buttons
    for (auto &btn : m_buttons) {
        if (btn) {
            btn->paint(painter, btn->geometry().toRect());
        }
    }

    painter->restore();
}
