#!/bin/bash

# ==========================================
# SAFE STRESS TEST - CPU, RAM, DISK for 24h
# ==========================================
# Created: $(date +%Y-%m-%d)
# Time: 24 hours
# Requires: stress-ng, lm-sensors (optional for temp monitoring)

LOG_DIR="./stress_logs"
mkdir -p "$LOG_DIR"

CPU_LOG="$LOG_DIR/cpu.log"
RAM_LOG="$LOG_DIR/ram.log"
DISK_LOG="$LOG_DIR/disk.log"

echo "=== BẮT ĐẦU STRESS TEST TOÀN HỆ THỐNG ==="
echo "Thời gian: 24 giờ"
echo "Log sẽ được lưu vào thư mục: $LOG_DIR"
echo ""

sleep 2

# ----------------------------
# CPU STRESS (Sử dụng 4 core)
# ----------------------------
echo "[1/3] Stress CPU (4 core)..."
stress-ng --cpu 4 --cpu-method all --timeout 24h --metrics-brief > "$CPU_LOG" &
CPU_PID=$!

# ----------------------------
# RAM STRESS (Sử dụng 2 tiến trình ~50% RAM mỗi cái)
# ----------------------------
echo "[2/3] Stress RAM (~100% RAM)..."
stress-ng --vm 2 --vm-bytes 50% --timeout 24h --metrics-brief > "$RAM_LOG" &
RAM_PID=$!

# ----------------------------
# DISK STRESS (Ghi 20GB mỗi vòng)
# ----------------------------
echo "[3/3] Stress DISK (1 tiến trình - ghi 20GB)..."
stress-ng --hdd 1 --hdd-bytes 20G --timeout 24h --metrics-brief > "$DISK_LOG" &
DISK_PID=$!

# ----------------------------
# MONITOR TIẾN TRÌNH
# ----------------------------
echo ""
echo "Đang chạy stress test... Nhấn Ctrl + C để hủy thủ công."
echo "Theo dõi nhiệt độ: sudo watch sensors"
echo ""

wait $CPU_PID
wait $RAM_PID
wait $DISK_PID

echo ""
echo "✅ Stress test hoàn tất!"
echo "📁 Xem log tại thư mục: $LOG_DIR"
