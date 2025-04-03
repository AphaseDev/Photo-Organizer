/**
 * @file poutils.h
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
#ifndef POUTILS_H
#define POUTILS_H

#include <QString>

namespace POUtils
{
Q_NAMESPACE

extern const QString Slash;
extern const QString FileQmlPrefix;

extern bool formatQmlUrlString(QString &p_filePath);

};

#endif // POUTILS_H
