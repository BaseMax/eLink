// Copyright (C) 2022 Kambiz Asadzadeh
// SPDX-License-Identifier: LGPL-3.0-only

#ifndef CLIPBOARD_HPP
#define CLIPBOARD_HPP

#include <QObject>

class ClipboardProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ dataText WRITE setDataText NOTIFY dataChanged)
    Q_PROPERTY(QString selectionText READ selectionText WRITE setSelectionText NOTIFY selectionChanged)
public:
    explicit ClipboardProxy(QObject *parent = 0);

    void setDataText(const QString& text);
    void setSelectionText(const QString& text);

    QString dataText() const;
    QString selectionText() const;

signals:
    void dataChanged();
    void selectionChanged();
};

#endif // CLIPBOARD_HPP
