/*
 * Copyright (c) 2014-2022 Stream.io Inc. All rights reserved.
 *
 * Licensed under the Stream License;
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    https://github.com/GetStream/stream-video-android/blob/main/LICENSE
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.getstream.video.flutter.stream_video_flutter.service.notification

import androidx.core.app.NotificationCompat

internal interface NotificationActionBuilder {

    fun createAcceptAction(
        notificationId: Int,
        callCid: StreamCallCid
    ): NotificationCompat.Action

    fun createRejectAction(
        notificationId: Int,
        callCid: StreamCallCid
    ): NotificationCompat.Action

    fun createCancelAction(
        notificationId: Int,
        callCid: StreamCallCid
    ): NotificationCompat.Action
}
