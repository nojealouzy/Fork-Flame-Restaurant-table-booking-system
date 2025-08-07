package term_project;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class TableBookingApp {

	private static Connection connect() throws SQLException {
	    Properties props = new Properties();
	    try (InputStream input = new FileInputStream("src/term_project/db.properties")) {
	        props.load(input);
	    } catch (IOException e) {
	        throw new SQLException("Could not load database properties", e);
	    }

	    String url = props.getProperty("db.url");
	    String user = props.getProperty("db.user");
	    String password = props.getProperty("db.password");

	    return DriverManager.getConnection(url, user, password);
	}


    static class TimeSlotItem {
        int id;
        String label;

        public TimeSlotItem(int id, String label) {
            this.id = id;
            this.label = label;
        }

        public String toString() {
            return label;
        }
    }

    public static void main(String[] args) {
        JFrame frame = new JFrame("Welcome to Fork & Flame");
        frame.setSize(600, 650);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        panel.setBackground(Color.WHITE);

        Font titleFont = new Font("Segoe UI", Font.BOLD, 20);
        Font labelFont = new Font("Segoe UI", Font.BOLD, 14);
        Font fieldFont = new Font("Segoe UI", Font.PLAIN, 13);

        JLabel title = new JLabel("Welcome to Fork & Flame", SwingConstants.CENTER);
        title.setFont(titleFont);
        title.setAlignmentX(Component.CENTER_ALIGNMENT);

        JLabel subtitle = new JLabel("Book Your Table", SwingConstants.CENTER);
        subtitle.setFont(labelFont);
        subtitle.setAlignmentX(Component.CENTER_ALIGNMENT);

        JLabel nameLabel = new JLabel("\uD83D\uDC64 Name:");
        nameLabel.setFont(labelFont);
        JTextField nameField = new JTextField();
        nameField.setFont(fieldFont);

        JLabel phoneLabel = new JLabel("\uD83D\uDCDE Phone Number:");
        phoneLabel.setFont(labelFont);
        JTextField phoneField = new JTextField();
        phoneField.setFont(fieldFont);

        JLabel dateLabel = new JLabel("\uD83D\uDDD5\uFE0F Booking Date (YYYY-MM-DD):");
        dateLabel.setFont(labelFont);
        JTextField dateField = new JTextField("2025-08-01");
        dateField.setFont(fieldFont);

        JLabel timeLabel = new JLabel("\uD83D\uDD52 Time Slot:");
        timeLabel.setFont(labelFont);
        JComboBox<TimeSlotItem> timeSlotDropdown = new JComboBox<>();
        timeSlotDropdown.setFont(fieldFont);

        JLabel tableLabel = new JLabel("\uD83C\uDF7D\uFE0F Table ID:");
        tableLabel.setFont(labelFont);
        JComboBox<String> tableDropdown = new JComboBox<>();
        tableDropdown.setFont(fieldFont);

        JButton bookButton = new JButton("\u2705 Make Booking");
        JButton cancelButton = new JButton("\u274C Cancel All Bookings");
        JButton viewButton = new JButton("\uD83D\uDCDA View My Bookings");

        bookButton.setFont(labelFont);
        cancelButton.setFont(labelFont);
        viewButton.setFont(labelFont);

        bookButton.setBackground(new Color(0, 153, 0));
        bookButton.setForeground(Color.WHITE);
        cancelButton.setBackground(new Color(204, 0, 0));
        cancelButton.setForeground(Color.WHITE);
        viewButton.setBackground(new Color(70, 130, 180));
        viewButton.setForeground(Color.WHITE);

        JTextArea outputArea = new JTextArea(6, 40);
        outputArea.setEditable(false);
        outputArea.setFont(fieldFont);
        JScrollPane scrollPane = new JScrollPane(outputArea);

        panel.add(title);
        panel.add(Box.createRigidArea(new Dimension(0, 10)));
        panel.add(subtitle);
        panel.add(Box.createRigidArea(new Dimension(0, 20)));

        panel.add(nameLabel); panel.add(nameField);
        panel.add(phoneLabel); panel.add(phoneField);
        panel.add(dateLabel); panel.add(dateField);
        panel.add(timeLabel); panel.add(timeSlotDropdown);
        panel.add(tableLabel); panel.add(tableDropdown);

        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 15, 10));
        buttonPanel.add(bookButton);
        buttonPanel.add(cancelButton);
        buttonPanel.add(viewButton);
        buttonPanel.setBackground(Color.WHITE);

        panel.add(buttonPanel);
        panel.add(new JLabel("\u25BC Output:"));
        panel.add(scrollPane);

        frame.setContentPane(panel);
        frame.setVisible(true);

        try (Connection con = connect();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT time_slot_id, slot_label FROM TimeSlots")) {
            while (rs.next()) {
                timeSlotDropdown.addItem(new TimeSlotItem(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        ActionListener updateTablesListener = e -> {
            tableDropdown.removeAllItems();
            try (Connection con = connect();
                 PreparedStatement stmt = con.prepareStatement("SELECT table_id FROM Tables ORDER BY table_id ASC")) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    tableDropdown.addItem(String.valueOf(rs.getInt("table_id")));
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        };

        dateField.addActionListener(updateTablesListener);
        timeSlotDropdown.addActionListener(updateTablesListener);

        bookButton.addActionListener(e -> {
            String name = nameField.getText();
            String phone = phoneField.getText();
            String bookingDate = dateField.getText();
            TimeSlotItem timeSlot = (TimeSlotItem) timeSlotDropdown.getSelectedItem();
            String tableIdStr = (String) tableDropdown.getSelectedItem();

            if (name.isEmpty() || phone.isEmpty() || tableIdStr == null || timeSlot == null || bookingDate.isEmpty()) {
                JOptionPane.showMessageDialog(frame, "All fields are required including available table.");
                return;
            }
            if (!phone.matches("\\d{10}")) {
                JOptionPane.showMessageDialog(frame, "Invalid phone number. Please enter a 10-digit number.",
                        "Validation Error", JOptionPane.WARNING_MESSAGE);
                return;
            }


            try (Connection con = connect()) {
                int customerId = -1;
                PreparedStatement findStmt = con.prepareStatement("SELECT customer_id FROM Customers WHERE phone = ?");
                findStmt.setString(1, phone);
                ResultSet rs = findStmt.executeQuery();
                if (rs.next()) {
                    customerId = rs.getInt(1);
                } else {
                    PreparedStatement insertStmt = con.prepareStatement("INSERT INTO Customers (customer_id, name, phone) VALUES (customer_seq.NEXTVAL, ?, ?)");
                    insertStmt.setString(1, name);
                    insertStmt.setString(2, phone);
                    insertStmt.executeUpdate();
                    ResultSet getIdStmt = con.createStatement().executeQuery("SELECT customer_seq.CURRVAL FROM dual");
                    if (getIdStmt.next()) {
                        customerId = getIdStmt.getInt(1);
                    }
                }

                CallableStatement stmt = con.prepareCall("{call booking_pkg.make_booking(?, ?, ?, ?, ?)}");
                stmt.setInt(1, customerId);
                stmt.setInt(2, Integer.parseInt(tableIdStr));
                stmt.setDate(3, java.sql.Date.valueOf(bookingDate));
                stmt.setInt(4, timeSlot.id);
                stmt.setInt(5, 1); // Always use status_id = 1 (Pending)
                stmt.execute();

                JOptionPane.showMessageDialog(frame,
                        "Booking Successful!\nName: " + name +
                                "\nPhone: " + phone +
                                "\nTable ID: " + tableIdStr +
                                "\nDate: " + bookingDate +
                                "\nTime: " + timeSlot);

                outputArea.setText("Booking successfully created.");
                updateTablesListener.actionPerformed(null);

            } catch (SQLException ex) {
                if (ex.getMessage().contains("ORA-20001")) {
                    outputArea.setText("\u26A0\uFE0F Table is already booked for the selected date/time.");
                } else {
                    outputArea.setText("\u274C Error: " + ex.getMessage());
                }
            }
        });

        cancelButton.addActionListener(e -> {
            String phone = phoneField.getText();
            if (phone.isEmpty()) {
                JOptionPane.showMessageDialog(frame, "Enter phone number to cancel bookings.");
                return;
            }

            try (Connection con = connect()) {
                int customerId = -1;
                PreparedStatement findStmt = con.prepareStatement("SELECT customer_id FROM Customers WHERE phone = ?");
                findStmt.setString(1, phone);
                ResultSet rs = findStmt.executeQuery();
                if (rs.next()) {
                    customerId = rs.getInt(1);
                } else {
                    outputArea.setText("No customer found with this phone.");
                    return;
                }

                CallableStatement stmt = con.prepareCall("{call booking_pkg.cancel_all_bookings_by_customer(?)}");
                stmt.setInt(1, customerId);
                stmt.execute();

                outputArea.setText("\u2705 Cancelled all bookings for customer ID: " + customerId);
                updateTablesListener.actionPerformed(null);
            } catch (SQLException ex) {
                outputArea.setText("\u274C Error: " + ex.getMessage());
            }
        });

        viewButton.addActionListener(e -> {
            String phone = phoneField.getText();
            if (phone.isEmpty()) {
                JOptionPane.showMessageDialog(frame, "Enter phone number to view bookings.");
                return;
            }
            try (Connection con = connect();
                 PreparedStatement stmt = con.prepareStatement(
                         "SELECT t.table_id, b.booking_date, ts.slot_label FROM bookings b " +
                                 "JOIN tables t ON b.table_id = t.table_id " +
                                 "JOIN timeslots ts ON b.time_slot_id = ts.time_slot_id " +
                                 "JOIN customers c ON b.customer_id = c.customer_id " +
                                 "WHERE c.phone = ? ORDER BY b.booking_date ASC")) {
                stmt.setString(1, phone);
                ResultSet rs = stmt.executeQuery();
                StringBuilder sb = new StringBuilder("Your Bookings:\n");
                while (rs.next()) {
                    sb.append("Table: ").append(rs.getInt(1))
                            .append(", Date: ").append(rs.getDate(2))
                            .append(", Time: ").append(rs.getString(3)).append("\n");
                }
                outputArea.setText(sb.toString());
            } catch (SQLException ex) {
                outputArea.setText("\u274C Error: " + ex.getMessage());
            }
        });
    }
}
