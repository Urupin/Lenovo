#include "clockbutton.h"
#include "clockdecoration_logging.h"

#include <KDecoration3/Decoration>
#include <KDecoration3/kdecoration3/decoratedwindow.h>
#include <QPainter>

ClockButton::ClockButton(KDecoration3::DecorationButtonType type, KDecoration3::Decoration *decoration, QObject *parent)
    : KDecoration3::DecorationButton(type, decoration, parent)
{
}

void ClockButton::setSize(int size)
{
    m_size = size;
}

void ClockButton::paint(QPainter *painter, const QRectF &)
{
    if (!decoration()) {
        return;
    }

    const QRectF rect = geometry();
    const bool isClose = (type() == KDecoration3::DecorationButtonType::Close);
    const bool hovered = isHovered();
    const bool pressed = isPressed();
    QColor bg = QColor(0, 0, 0, 0);

    if (hovered || pressed) {
        bg = isClose ? m_closeColor : m_hoverColor;
        if (!(decoration()->window() && decoration()->window()->isActive())) {
            bg.setAlphaF(0.6);
        } else if (pressed) {
            bg = bg.darker(120);
        }
    }

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, true);

    if (bg.alpha() > 0) {
        painter->setPen(Qt::NoPen);
        painter->setBrush(bg);
        painter->drawEllipse(rect.adjusted(2, 2, -2, -2));
    }

    const bool active = decoration()->window() && decoration()->window()->isActive();
    QColor fg = active ? m_activeColor : m_inactiveColor;
    if (hovered) {
        fg = Qt::white;
    }
    painter->setPen(QPen(fg, 1.8, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    paintSymbol(painter, rect);

    painter->restore();
}

void ClockButton::paintSymbol(QPainter *painter, const QRectF &buttonRect)
{
    const qreal margin = 6.0;
    const QRectF symbolRect = buttonRect.adjusted(margin, margin, -margin, -margin);

    switch (type()) {
    case KDecoration3::DecorationButtonType::Close:
        painter->drawLine(symbolRect.topLeft(), symbolRect.bottomRight());
        painter->drawLine(symbolRect.topRight(), symbolRect.bottomLeft());
        break;
    case KDecoration3::DecorationButtonType::Minimize:
        painter->drawLine(QPointF(symbolRect.left(), symbolRect.center().y()),
                          QPointF(symbolRect.right(), symbolRect.center().y()));
        break;
    case KDecoration3::DecorationButtonType::Maximize:
        painter->drawRect(symbolRect);
        break;
    default:
        break;
    }
}
