package dao;

import entities.Activite;
import entities.User;
import java.util.List;
import java.util.Set;

public interface IUserDAO {
	boolean create(User user);
    User findById(Long id);
    List<User> findAll();
    boolean  update(User user);
    boolean delete(Long id);
    User findByNom(String nom);
    User findByEmail(String email);
	String getLastError();
	int getParticipationCount(Long userId);
	boolean isUserInWaitingList(Long userId, Long activiteId);
	boolean isUserParticipating(Long userId, Long activiteId);
	Set<Activite> getUserParticipations(Long userId);
}
