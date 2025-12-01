# Hướng dẫn Submit Repository vào HACS Default

## Thông tin Repository

- **Repository**: `ngoviet/camera-card-ha`
- **Category**: `plugin` (Frontend/Lovelace)
- **Name**: Advanced Camera Card
- **Description**: A comprehensive camera card for Home Assistant
- **Home Assistant**: 2022.3.0
- **HACS**: 1.6.0

## Yêu cầu đã đáp ứng ✅

- ✅ Repository là public
- ✅ Issues đã enable
- ✅ Topics đã thêm (hacs, home-assistant, lovelace, camera-card)
- ✅ Release v0.1.6 với assets (157 files)
- ✅ hacs.json đúng format
- ✅ Main file: advanced-camera-card.js exists
- ✅ GitHub Actions HACS validation đã chạy

## Các bước Submit

### Bước 1: Fork Repository

1. Truy cập: https://github.com/hacs/default
2. Click nút **Fork** ở góc trên bên phải
3. Chọn account của bạn để fork

### Bước 2: Clone và Tạo Branch

```bash
git clone https://github.com/YOUR_USERNAME/default.git
cd default
git checkout -b add-ngoviet-camera-card-ha
```

### Bước 3: Thêm Repository vào File Plugin

1. Mở file `./plugin` (đây là file JSON array)
2. Tìm vị trí phù hợp theo thứ tự alphabet (sau các repository bắt đầu bằng "n")
3. Thêm entry: `"ngoviet/camera-card-ha",` (với dấu phẩy và dấu ngoặc kép)
4. Đảm bảo format JSON đúng (mỗi repository là một string trong array)

**Format file plugin (JSON array):**
```json
[
  "0Paul89/vienna-transport-card",
  "0xAHA/solar-bar-card",
  ...
  "nguyenpham/...",
  "ngoviet/camera-card-ha",  <- Thêm ở đây
  ...
]
```

**Lưu ý:**
- File là JSON array, không phải object
- Mỗi repository là một string trong array
- Thêm dấu phẩy sau entry (trừ entry cuối cùng)
- Giữ nguyên thứ tự alphabet

### Bước 4: Commit và Push

```bash
git add plugin  # hoặc plugin.json
git commit -m "Add ngoviet/camera-card-ha to default repositories"
git push origin add-ngoviet-camera-card-ha
```

### Bước 5: Tạo Pull Request

1. Truy cập: https://github.com/YOUR_USERNAME/default
2. Click **Compare & pull request**
3. Điền thông tin:
   - **Title**: `Add ngoviet/camera-card-ha to default repositories`
   - **Description**: 
     ```
     ## Repository Information
     - Repository: ngoviet/camera-card-ha
     - Category: plugin (Frontend/Lovelace)
     - Name: Advanced Camera Card
     - Description: A comprehensive camera card for Home Assistant
     
     ## Requirements Met
     - ✅ Public repository
     - ✅ Issues enabled
     - ✅ Topics added (hacs, home-assistant, lovelace, camera-card)
     - ✅ Release v0.1.6 with assets
     - ✅ Valid hacs.json
     - ✅ HACS validation passed
     
     ## Links
     - Repository: https://github.com/ngoviet/camera-card-ha
     - Release: https://github.com/ngoviet/camera-card-ha/releases/tag/v0.1.6
     ```
4. Click **Create pull request**

### Bước 6: Đợi Review

- Maintainer sẽ review PR
- Có thể cần chỉnh sửa theo feedback
- Sau khi merge, repository sẽ có trong HACS default list

## Lưu ý

- Chỉ chủ sở hữu hoặc người đóng góp chính của repository mới có thể submit
- Repository phải đáp ứng tất cả yêu cầu của HACS
- Quá trình review có thể mất vài ngày đến vài tuần
- Sau khi merge, repository sẽ có sẵn trong HACS trong lần quét tiếp theo

## Tham khảo

- HACS Documentation: https://hacs.xyz/docs/publish/include/
- HACS Default Repository: https://github.com/hacs/default

