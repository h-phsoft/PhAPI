CREATE OR REPLACE PROCEDURE Notif_Delete_OLD_Notifications IS
Begin
  DELETE FROM Notif_Notif WHERE (TO_DATE(TO_CHAR(Sysdate,'DD-MM-YYYY'), 'DD-MM-YYYY')-TO_DATE(TO_CHAR(SDate,'DD-MM-YYYY'), 'DD-MM-YYYY'))> 7;
END Notif_Delete_OLD_Notifications;
/
