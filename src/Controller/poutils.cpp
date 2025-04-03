/**
 * @file poutils.cpp
 * @class POUtils
 * @author Benoît MOUFLIN
 * @date 2025-03-31
 *
 * @brief The POUtils class
 *
 * @module Photo Organizer
 * @note Stores several tool functions for managing strings and files.
 *
 * Copyright (c) 2024 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
#include "poutils.h"

const QString POUtils::Slash = QStringLiteral("/");
const QString POUtils::FileQmlPrefix = QStringLiteral("file:///");


bool POUtils::formatQmlUrlString(QString &p_filePath)
{
    if (p_filePath.isEmpty()) {
        return false;
    }
    if (p_filePath.length() > 11) {
        if (p_filePath.startsWith(POUtils::FileQmlPrefix, Qt::CaseInsensitive)) {
            p_filePath = p_filePath.mid(6, p_filePath.length());
        } else if (p_filePath.startsWith(QLatin1String("file://"), Qt::CaseInsensitive)) {
            p_filePath = p_filePath.mid(5, p_filePath.length());
        }
        if (QStringView{p_filePath}.mid(3,2).compare(QLatin1String(":/")) == 0)  {
            p_filePath = p_filePath.mid(2, p_filePath.length() - 2);
        }
    }
    p_filePath.replace(QLatin1String("\\"), POUtils::Slash);
    p_filePath.replace(QLatin1String("///"), POUtils::Slash);
    return true;
}
